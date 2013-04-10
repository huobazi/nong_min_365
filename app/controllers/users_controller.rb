# -*- encoding : utf-8 -*-
class UsersController < ApplicationController
  before_filter :require_not_login, :only => [:new, :create]
  before_filter :require_login, :only => [:edit, :save, :my_items, :change_password, :update_password]

  def new
    @user = User.new
    @page_title = '用户注册'
    drop_breadcrumb(@page_title, signup_path)

    fresh_when 
    expires_in 10.minutes
  end

  def create
    @page_title = '用户注册'
    @user = User.new(get_create_params) 
    if @user.save
      msg = "注册成功！强烈建议您完善个人信息，以便更好的体验本站的服务！"
      msg = "您没有填写邮件信息，强烈建议您登记邮件，否则您忘记密码，将无法找回您的密码！" if @user.email.blank?
      redirect_to edit_users_path, :alert => msg
    else
      render 'new'
    end
  end

  def edit
    @user = current_user
    @page_title = '个人信息'
    drop_breadcrumb(@page_title, edit_users_path)

    respond_to do |wants|
      wants.html{ render :layout => 'my' }
      wants.mobile
    end
  end

  def save
    @user = current_user
    @page_title = '个人信息'
    drop_breadcrumb(@page_title, edit_users_path)

    if @user.update_attributes get_edit_params
      msg = "个人信息修改成功！"
      msg = "您没有填写邮件信息，强烈建议您登记邮件，否则您忘记密码，将无法找回您的密码！" if @user.email.blank?
      redirect_to edit_users_path, :alert => msg
    else
      render 'edit', :layout => 'my'
    end
  end

  def my_items
    @page_title = '我的产品'
    drop_breadcrumb(@page_title, my_items_users_path)

    page_size   = 10
    page_index  = params[:page]
    @items = current_user.items.page(page_index).per(page_size) 

    respond_to do |wants|
      wants.html{ render :layout => 'my' } 
      wants.mobile 
    end
  end

  def change_password
    @user = User.new
    @page_title = '修改密码'
    drop_breadcrumb(@page_title, change_password_users_path)

    respond_to do |wants|
      wants.html{ render :layout => 'my' }
      wants.mobile
    end
  end

  def update_password
    @page_title = '修改密码'
    drop_breadcrumb(@page_title, change_password_users_path)

    post_params = get_update_password_params
    current_password = post_params[:current_password]
    @user = current_user

    if @user.authenticate(current_password) 
      if @user.update_attributes(post_params)
        @user.generate_token(:remember_token)
        sign_out
        redirect_to signin_path, :alert => '您已经修改了密码,请使用新密码重新登录!'
      else
        render "change_password", {:layout => 'my', :notice => '修改密码不成功，请重试。'}
      end
    else
      @user.errors.add(:current_password, current_password.blank? ? :blank : :invalid)
      render "change_password", {:layout => 'my', :notice => '当前密码输入错误!'}
    end
  end

  private
  def get_create_params
    params[:user].slice(:username,:password, :password_confirmation, :email)
  end

  def get_edit_params
    params[:user].slice(:email, :qq, :cellphone)
  end

  def get_update_password_params
    params[:user].slice(:current_password, :password, :password_confirmation)
  end

end
