# -*- encoding : utf-8 -*-
class Admincp::SmsController < Admincp::ApplicationController
  def new
  end

  def create
    phone_input = params[:sms][:phones]
    content = params[:sms][:content]
    phone_ary = phone_input.split("\r\n")
    
    SmsQueueWorker.perform_async(phone_ary, content)

    redirect_to admincp_new_sms_path, notice: '群发已经进入队列.' 
  end

end
