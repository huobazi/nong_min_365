# -*- encoding : utf-8 -*-

class SmsQueueWorker
  include Sidekiq::Worker
  sidekiq_options retry: false, :queue => 'sms', :backtrace => true

  def perform(phone_ary, content)
    if !phone_ary.is_a?(Array) 
      raise 'phones must be a array'
    end
    phone_ary.each do |phone|
      SmsSendWorker.perform_async(phone.to_s.strip, content)
    end
  end

end

