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

  def batch
  end

  def batch_create
    phone_ary = []
    content = params[:sms][:content]
    items = Item.select('contact_phone').limit(500).where(:user_id => -1).order('id desc')

    items.each do |item|
      phone_ary.push(item.contact_phone.strip)
    end

    SmsQueueWorker.perform_async(phone_ary, content)

    redirect_to admincp_batch_sms_path, notice: '群发已经进入队列.' 
  end
end
