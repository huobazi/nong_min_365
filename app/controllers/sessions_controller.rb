# -*- encoding : utf-8 -*-
class SessionsController < ApplicationController

  def new
  end

  # POST /sessions
  # POST /sessions.json
  def create
    sign_in_params = params[:session]
    login = sign_in_params[:login]
    password = sign_in_params[:password]
    remember_me = sign_in_params[:remember_me] == '1'
    
    user = User.authenticate_by_username(login, password)

    respond_to do |format|
      if user 
        sign_in_as user
        if remember_me
          set_remember_me
        end
        format.html { redirect_to root_url, :notice => "登陆成功!"}
        format.json { render json: @user, status: :created }
      else
        format.html {
          flash.now.alert = "用户名或密码错误!"
          render action: "new"
        }
        format.json { render json: "errors", status: :unprocessable_entity }
      end
    end
  end

  # DELETE /sessions/1
  # DELETE /sessions/1.json
  def destroy
    sign_out
    respond_to do |format|
      format.html { redirect_to root_url ,:notice => '退出成功!'}
      format.json { head :no_content }
    end
  end

end

