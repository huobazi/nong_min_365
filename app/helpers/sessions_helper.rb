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
  end

  def current_user=(user)
    @current_user = user
  end

  def current_user
    @current_user || User.find(session[:user_id]) if session[:user_id] 
  end

  def current_user?(user)
    user == current_user 
  end

  def signed_in?
    !current_user.nil?
  end
end
