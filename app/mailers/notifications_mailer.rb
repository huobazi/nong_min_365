# -*- encoding : utf-8 -*-
class NotificationsMailer < ActionMailer::Base

  default :from => "天天农业<webmaster@nongmin365.com>",
  :to           => "huobazi@gmail.com",
  :charset      => "utf-8",
  :content_type => "text"

  def contact_us_mail(message)
    @message = message
    mail(
      :to => 'huobazi@gmail.com', 
      :subject => "[天天农业-联系我们] #{message.subject}",
      :tag => 'nongming365_contact_us'
    ) 
  end

end
