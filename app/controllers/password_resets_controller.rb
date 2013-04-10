# -*- encoding : utf-8 -*-
class PasswordResetsController < ApplicationController
  def new
    @page_title = "找回密码"
    drop_breadcrumb(@page_title, '')
  end

  def create
    @page_title = "找回密码"
    drop_breadcrumb(@page_title, new_password_reset_path)
    user = User.find_by_username(params[:password_reset][:username])
    if user
      user.send_password_resets
      redirect_to signin_path, notice: '密码重置邮件已经发往您的邮箱，请您登陆您的邮箱按照提示操作。'
    else
      redirect_to new_password_reset_path
    end
  end

  def show
    @page_title = "找回密码"
    drop_breadcrumb(@page_title, password_reset_path(params[:id]))
    @user = User.find_by_password_reset_token!(params[:id])

    if @user.password_reset_sent_at < 3.hours.ago
      redirect_to new_password_reset_path, :alert => "该找回密码连接已过期，您需要重新找回密码。"
    end
  end

  def update
    @page_title = "找回密码"
    drop_breadcrumb(@page_title, password_reset_path(params[:id]))
    @user = User.find_by_password_reset_token!(params[:id])
    post_params = get_update_password_params

    if @user.password_reset_sent_at < 3.hours.ago
      redirect_to new_password_reset_path, :alert => "该找回密码连接已过期，您需要重新找回密码。"
    elsif @user.update_attributes(post_params)
      @user.generate_token(:remember_token)
      sign_out
      redirect_to signin_url, :notice => "密码已修改，请使用新密码登陆。"
    else
      render :show
    end
  end

  private
  def get_update_password_params
    params[:user].slice(:password, :password_confirmation)
  end

end
