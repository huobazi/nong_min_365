class NotificationsMailer < ActionMailer::Base

  default :from         => "webmaster@nongmin365.com"
  default :to           => "huobazi@gmail.com"
  default :charset      => "utf-8"
  default :content_type => "text"

  def contact_us_mail(message)
    @message = message
    mail(
      :from => 'webmaster@nongmin365.com',
      :to => 'huobazi@gmail.com', 
      :subject => "[天天农业-联系我们] #{message.subject}",
      :tag => 'contact_us'
    ) 
  end

end
