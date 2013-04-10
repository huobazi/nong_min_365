# -*- encoding : utf-8 -*-
class SessionsController < ApplicationController
  before_filter :require_login, :only => [:destroy]
  before_filter :require_not_login, :only => [:new, :create]

  def new
    @page_title = '用户登录'
    fresh_when 
    expires_in 10.minutes
  end

  # POST /sessions
  def create
    @page_title = '用户登录'
    sign_in_params = params[:session]
    login = sign_in_params[:login]
    password = sign_in_params[:password]
    remember_me = sign_in_params[:remember_me] == '1'

    user = User.authenticate_by_username(login, password)

    if user
      sign_in_as user
      if remember_me
        set_remember_me
      end
      redirect_to root_url, :notice => "登陆成功!"
    else
      flash.now.alert = "用户名或密码错误!"
      render "new"
    end
  end

  # DELETE /sessions/1
  def destroy
    sign_out
    redirect_to root_url ,:notice => '退出成功!'
  end
end

