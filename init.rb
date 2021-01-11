require 'bunny'
require_dependency "notifier_hook"

Redmine::Plugin.register :rabbitmq do
  name 'Rabbitmq plugin'
  author 'Василий Казьмин'
  description 'This is a plugin for Redmine'
  version '0.0.1'
  url 'https://github.com/awk-kazmin/rabbitmq'
  author_url 'http://example.com/about'
  settings :default => {
    "username" => "guest", 
    "password" => "guest", 
    "exchange" => "redmine", 
    "server" => "rabbitmq", 
    "port" => 5672
  }, :partial => "settings/rabbitmq_settings"
end
