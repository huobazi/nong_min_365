# -*- encoding : utf-8 -*-
class SmsWorker
  include Sidekiq::Worker
  sidekiq_options retry: false

  def perfor(phone, content)
    
  end

end
