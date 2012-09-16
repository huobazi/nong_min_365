# -*- encoding : utf-8 -*-
class UsersController < ApplicationController
  before_filter :require_not_login, :only => [:new, :create]

  def new
    @user = User.new
  end

  def create
    @user = User.new(get_create_params) 
    if @user.save
      redirect_to root_url, :notice => "注册成功！" 
    else
      render 'new'
    end
  end

  private
  def get_create_params
    params[:user].slice(:username,:password)
  end

end
