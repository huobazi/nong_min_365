# -*- encoding : utf-8 -*-

require 'rest_client'

class SmsBao
  
  def initialize(user_name, password, args = nil)
    args = args || {}
    @user_name = user_name
    @password_md5 = Digest::MD5.hexdigest password
  end

  def send_message(phone, content) 
    api_url  = "http://www.smsbao.com/sms"
    phone = (phone.is_a Array) ? phone.join(',') : phone.to_s
    params   = {:params => {:u => @user_name, :p => @password_md5 , :m => phone, :c => URI.escape(content)}}
    response = RestClient.get api_url, params
    response
  end

  def query_balance
    api_url  = "http://www.smsbao.com/query"
    params   = {:params => {:u => @user_name, :p => @password_md5 }}
    response = RestClient.get api_url, params
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
