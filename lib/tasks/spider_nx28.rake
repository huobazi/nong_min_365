# -*- encoding : utf-8 -*-
require 'slack-notifier'
namespace :spider do
  desc 'Crawl nx28 items'
  task :nx28 => :environment do

    begin
      ::Nx28Spider.new.run_spider
    rescue => exception
      title = 'Nx28Spider Exception'
      message += "*Project:* #{Rails.application.class.parent_name}\n"
      message += "*Environment:* #{Rails.env}\n"
      message += "*Time:* #{Time.zone.now.strftime('%Y-%m-%d %H:%M:%S')}\n"
      message += "*Exception:* `#{exception.message}`\n"

      message += "*Backtrace*: \n"
      message += "`#{exception.backtrace.first}`"

      webhook_url = 'https://hooks.slack.com/services/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'
      notifier = Slack::Notifier.new webhook_url, channel: '#nm365_prd',
        username: 'nx28_spider',
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
