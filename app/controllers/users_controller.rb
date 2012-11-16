# -*- encoding : utf-8 -*-
class UsersController < ApplicationController
  before_filter :require_not_login, :only => [:new, :create]
  before_filter :require_login, :only => [:change_password, :update_password]

  def new
    @title = '用户注册'
    @user = User.new
  end

  def create
    @title = '用户注册'
    @user = User.new(get_create_params) 
    if @user.save
      redirect_to root_url, :notice => "注册成功！" 
    else
      render 'new' 
    end
  end

  def change_password
    @user = User.new
  end

  def update_password
    post_params = get_update_password_params
    current_password = post_params[:current_password]
    @user = current_user

    if @user.authenticate(current_password) 
      if @user.update_attributes(post_params)
        @user.generate_token(:remember_token)
        sign_out
        redirect_to root_path, :notice => '您已经修改了密码,请使用新密码重新登录!'
      else
        render "change_password" 
      end
    else
      @user.errors.add(:current_password, current_password.blank? ? :blank : :invalid)
      render "change_password" ,:notice => '当前密码输入错误!'
    end
  end

  private
  def get_create_params
    params[:user].slice(:username,:password, :password_confirmation)
  end

  def get_update_password_params
    params[:user].slice(:current_password, :password, :password_confirmation)
  end

end
