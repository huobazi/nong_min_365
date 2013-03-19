# -*- encoding : utf-8 -*-

require 'rest_client'
class SmsSendWorker
  include Sidekiq::Worker
  sidekiq_options retry: false

  def perform(phone, content)
    sms_bao = SmsBao.new(SiteSettings.smsbao_uname,SiteSettings.smsbao_pwd)
    sms_bao.send_message(phone, content)
  end

  class SmsBao
    def initialize(user_name, password, args = nil)
      args = args || {}
      @user_name = user_name
      @password_md5 = Digest::MD5.hexdigest password
    end

    def send_message(phone, message) 
      phone = (phone.is_a? Array) ? phone.join(',') : phone.to_s
      response =  
        RestClient.get 'http://www.smsbao.com/sms?u='+@user_name+'&p='+@password_md5+'&m='+phone+'&c='+URI.escape(message)
      response
    end

    def query_balance
      response = 
        RestClient.get('http://www.smsbao.com/query?u='+@user_name+'&p='+@password_md5).split(',')[1].to_i
      response
    end

    private
    def get_result code
      case code 
      when '0'
        'success'
      when '30' 
        'password error'
      when '40'
        'bad account'
      when '41'
        'no money'
      when '42'
        'account expired'
      when '43'
        'IP denied'
      when '50'
        'content sensitive'
      when '51'
        'bad phone number'
      else 
        'unknown error'
      end
    end
  end
end

