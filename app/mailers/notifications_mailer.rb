# -*- encoding : utf-8 -*-
class NotificationsMailer < ActionMailer::Base

  default :from => "webmaster@nongmin365.com",
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

  def password_reset_mail(user)
    @user = user
    mail(
      :to => user.email,
      :subject => "[天天农业]-找回密码",
      :tag => 'nongming365_password_reset'
    )
  end

end
