# -*- encoding : utf-8 -*-
module SessionsHelper

  protected
  def sign_in_as(user)
    session[:user_id] = user.id
    @current_user = user
  end

  def sign_out
    @current_user = nil
    session.delete(:user_id) 
    cookies.delete(:remember_token)
  end

  def current_user
    @current_user ||= (User.find(session[:user_id]) if session[:user_id]) 
    @current_user ||= (User.find_by_remember_token(cookies[:remember_token]) if cookies[:remember_token])
  end

  def signed_in?
    !!current_user
  end

  def set_remember_me
    cookies[:remember_token] = {
      :value => @current_user.remember_token,
      :expires => 2.weeks.from_now
    }
  end
end
