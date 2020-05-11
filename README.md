# RabbitMQ Plugin for Redmine

This plugin is intended to provide basic integration with RabbitMQ , by sending notifications of updates to issues to a RabbitMQ.

Following actions will result in notifications to Jabber:

- Create and update issues

## Installation & Configuration

- The RabbitMQ Notifications Plugin depends on the [bunny](https://github.com/ruby-amqp/bunny). This can be installed with: $ gem install bunny
- Then install the Plugin following the general Redmine [plugin installation instructions](http://www.redmine.org/wiki/redmine/Plugins).
- Go to the Plugins section of the Administration page, select Configure.
- On this page fill out the Jabber ID and password for user who will sends messages, and the MUC room where to send messages to.
- Restart your Redmine web servers (e.g. mongrel, thin, mod_rails).