require 'exception_notification/rails'
# 自定义 notifier(slack)
module ExceptionNotifier
  class SlackNotifier

    attr_accessor :slack_options

    def initialize(options)
      self.slack_options = options
    end

    def call(exception, options={})
      env = options[:env]

      link = env['HTTP_HOST'] + env['REQUEST_URI']
      title = "#{env['REQUEST_METHOD']} <http://#{link}|http://#{link}>\n"

      message = "------------------------------------------------------------------------------------------\n"
      message += "*Project:* #{Rails.application.class.parent_name}\n"
      message += "*Environment:* #{Rails.env}\n"
      message += "*Time:* #{Time.zone.now.strftime('%Y-%m-%d %H:%M:%S')}\n"
      message += "*Exception:* `#{exception.message}`\n"

      req = Rack::Request.new(env)
      unless req.params.empty?
        message += "*Parameters:*\n"
        message += req.params.map { |k, v| ">#{k}=#{v}" }.join("\n")
        message += "\n"
      end
      message += "*Backtrace*: \n"
      message += "`#{exception.backtrace.first}`"

      notifier = Slack::Notifier.new slack_options.fetch(:webhook_url),
                                     channel: slack_options.fetch(:channel),
                                     username: slack_options.fetch(:username),
                                     # icon_emoji: slack_options.fetch(:icon_emoji),
                                     attachments: [{
                                                       color: 'danger',
                                                       title: title,
                                                       text: message,
                                                       mrkdwn_in: %w(text title fallback)
                                                   }]
      notifier.ping ''
    end
  end
end


ExceptionNotification.configure do |config|
  # Ignore additional exception types.
  # ActiveRecord::RecordNotFound, AbstractController::ActionNotFound and ActionController::RoutingError are already added.
  # config.ignored_exceptions += %w{ActionView::TemplateError CustomError}

  # Adds a condition to decide when an exception must be ignored or not.
  # The ignore_if method can be invoked multiple times to add extra conditions.
  # config.ignore_if do |exception, options|
  #   not Rails.env.production?
  # end

  # Notifiers =================================================================

  # Email notifier sends notifications by email.
  #config.add_notifier :email, {
    #:email_prefix         => "[ERROR] ",
    #:sender_address       => %{"Notifier" <notifier@example.com>},
    #:exception_recipients => %w{exceptions@example.com}
  #}

  # Campfire notifier sends notifications to your Campfire room. Requires 'tinder' gem.
  # config.add_notifier :campfire, {
  #   :subdomain => 'my_subdomain',
  #   :token => 'my_token',
  #   :room_name => 'my_room'
  # }

  # HipChat notifier sends notifications to your HipChat room. Requires 'hipchat' gem.
  # config.add_notifier :hipchat, {
  #   :api_token => 'my_token',
  #   :room_name => 'my_room'
  # }

  # Webhook notifier sends notifications over HTTP protocol. Requires 'httparty' gem.
  # config.add_notifier :webhook, {
  #   :url => 'http://example.com:5555/hubot/path',
  #   :http_method => :post
  # }

  config.add_notifier :slack, {
    :webhook_url => "https://hooks.slack.com/services/--------------------------",
    :channel     => "nm365_prd",
    :username => "huobazi"
  }
end
