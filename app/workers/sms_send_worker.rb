# -*- encoding : utf-8 -*-
require 'sms_bao'
class SmsSendWorker
  include Sidekiq::Worker
  sidekiq_options retry: false, :queue => 'sms', :backtrace => true

  def perform(phone, content)
    sms_bao = SmsBao.new(SiteSettings.smsbao_uname,SiteSettings.smsbao_pwd)
    sms_bao.send_message(phone, content)
  end
end

