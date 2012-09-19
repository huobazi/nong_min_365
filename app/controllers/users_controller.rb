# -*- encoding : utf-8 -*-
class UsersController < ApplicationController
  before_filter :require_not_login, :only => [:new, :create]
  before_filter :require_login, :only => [:change_password, :update_password]

  def new
    @user = User.new
  end

  def create
    @user = User.new(get_create_params) 
    respond_to do |format|
      if @user.save
        format.html { redirect_to root_url, :notice => "注册成功！" }
        format.json { render json: @user, status: :created }
      else
        format.html { render 'new' }
      end
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
      respond_to do |format|
        if @user.update_attributes(post_params)
          @user.generate_token(:remember_token)
          sign_out
          format.html{
            redirect_to root_path, :notice => '您已经修改了密码,请使用新密码重新登录!'
          }
          format.json { render json: @user, status: :created }
        else
          format.html { render "change_password" }
          format.json { render json: "errors", status: :unprocessable_entity }
        end
      end
    else
      @user.errors.add(:current_password, current_password.blank? ? :blank : :invalid)
      respond_to do |format|
        format.html { render "change_password" ,:notice => '当前密码输入错误!'}
        format.json { render json: "errors", status: :unprocessable_entity }
      end
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
