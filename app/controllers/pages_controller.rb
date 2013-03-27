# -*- encoding : utf-8 -*-
class PagesController < HighVoltage::PagesController
  caches_page :show
  layout :layout_for_page
  before_filter :set_page_title_and_breadcrumb_and_data
  
  # for debug
  #rescue_from ActionView::MissingTemplate do |exception|
  #raise exception
  #end

  def contact_create
    @message = MailMessage.new(params[:mail_message])

    respond_to do |wants|
      if @message.save
        #NotificationsMailer.delay.contact_us_mail(@message)
        NotificationsMailer.contact_us_mail(@message).deliver
        flash[:notice] = '留言已发送，感谢您关心我们的成长。' 
        wants.html { redirect_to root_path }
      else
        wants.html { render "contact"  }
      end
    end
  end

  private
  def layout_for_page
    case params[:id]
    when /^errors/
      'errors'
    when 'about'
      'static'
    else
      'static'
    end
  end

  def set_page_title_and_breadcrumb_and_data
    case params[:id] 
    when /^errors/
      @page_title = '出错啦'
    when 'about'
      @page_title = '关于我们'
      drop_breadcrumb(@page_title, static_page_path('about'))
    when 'help'
      @page_title = '帮助中心'
      drop_breadcrumb(@page_title, static_page_path('help'))  
    when 'contact'
      @page_title = '联系我们'
      @message = MailMessage.new
      drop_breadcrumb(@page_title, static_page_path('contact'))  
    end
  end

end
