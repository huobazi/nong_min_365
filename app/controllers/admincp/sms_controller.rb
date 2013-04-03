# -*- encoding : utf-8 -*-
class Admincp::SmsController < Admincp::ApplicationController
  def new
  end

  def create
    phone_ary = []
    phone_input = params[:sms][:phones]
    content = params[:sms][:content]
    phone_input.split("\r\n").each do |el|
      phone_ary.push(el.strip) if(el.strip.size == 11)
    end
    
    SmsQueueWorker.perform_async(phone_ary, content)

    redirect_to admincp_new_sms_path, notice: "共有#{phone_ary.size}条短信进入群发队列."
  end

  def batch
  end

  def batch_create
    phone_ary = []
    content = params[:sms][:content]
    categories = Category.all
    categories.each do |category|
      items = Item.select('contact_phone, created_at').limit(15).offset(22).where(:category_id => category.id, :user_id => -1).order('id desc')
      items.each do |item|
        #phone_ary.push(item.contact_phone.strip) if(item.created_at.day == Time.now.day and item.contact_phone.to_s.strip.size == 11)
        phone_ary.push(item.contact_phone.strip) if( item.contact_phone.to_s.strip.size == 11)
      end
    end
    
    SmsQueueWorker.perform_async(phone_ary.uniq, content)

    redirect_to admincp_batch_sms_path, notice: "共有#{phone_ary.size}条短信进入群发队列."
  end
end
