class NotifierHook < Redmine::Hook::Listener
  def controller_issues_new_after_save(context = {})
    deliver(make_msg(context[:issue]), make_key("issue", context[:issue].project.id, "new")) unless !validate_settings?
  end

  def controller_issues_edit_after_save(context = {})
    deliver(make_msg(context[:issue]), make_key("issue", context[:issue].project.id, "update")) unless !validate_settings?
    if context[:time_entry]
      deliver(make_msg(context[:time_entry]), make_key("time_entry", context[:time_entry].issue.project.id, "update")) unless !validate_settings?
    end
  end

  def controller_timelog_edit_before_save(context = {})
    deliver(make_msg(context[:time_entry]), make_key("time_entry", context[:time_entry].issue.project.id, "update")) unless !validate_settings?
  end

  private

  def logger
    config.logger
  end

  def notify_error(e)
    logger.error "RabbitMQ Hook error => exception #{e.class.name} : #{e.message}"
    flash[:error] = "Exception caught while delivering notification to RabbitMQ channel"
  end

  def settings
    @settings ||= Setting.plugin_rabbitmq
  end

  def validate_settings?
    settings["username"].present? && settings["password"].present? && settings["exchange"].present? && settings["server"].present? && settings["port"].present?
  end

  def make_msg(issue)
    message = issue.to_json
    return message
  end

  def make_key(object, project, event)
    message = "redmine.#{project}.#{object}.#{event}"
    return message
  end

  def make_exchange()
    connection = Bunny.new(:host => settings["server"],
                           :port => settings["port"],
                           :user => settings["username"],
                           :pass => settings["password"])
    connection.start
    channel = connection.create_channel
    exchange = channel.fanout(settings["exchange"])
    yield exchange
  ensure
    connection.close
  end

  def deliver(message, key)
    make_exchange do |exchange|
      exchange.publish(
        message,
        :routing_key => key,
        :content_type => "application/json",
      )
    end
  end
end
