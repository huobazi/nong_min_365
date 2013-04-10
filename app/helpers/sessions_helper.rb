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
    cookies.signed[:_remember_token] = nil
  end

  def current_user
    @current_user ||= ( User.find(session[:user_id]) if session[:user_id] ) 
    if !@current_user
      @current_user ||= ( User.find_by_remember_token(cookies.signed[:_remember_token]) if cookies.signed[:_remember_token] )
      sign_in_as(@current_user) if @current_user
    end
    @current_user
  end

  def signed_in?
    !!current_user
  end

  def require_login
    if !signed_in?
      respond_to do |format|
        format.html { redirect_to main_app.signin_path }
        format.mobile { redirect_to main_app.signin_path }
        format.json { head(:unauthorized) }
      end
    end
  end

  def require_not_login
    if signed_in?
      respond_to do |format|
        format.html { redirect_to root_path }
        format.mobile { redirect_to root_path }
        format.json { head(:unauthorized) }
      end
    end
  end

def require_admin_or_founder
    require_login
    if !current_user.has_role?(:admin) and !current_user.has_role?(:founder)
      respond_to do |format|
        format.html { redirect_to main_app.signin_path, :notice => '您未被授权访问此页面!' }
        format.mobile { redirect_to main_app.signin_path, :notice => '您未被授权访问此页面!' }
        format.json { head(:unauthorized) }
      end
    end
  end


  def require_admin
    require_login
    if !current_user.has_role?(:admin)
      respond_to do |format|
        format.html { redirect_to main_app.signin_path, :notice => '您未被授权访问此页面!' }
        format.mobile { redirect_to main_app.signin_path, :notice => '您未被授权访问此页面!' }
        format.json { head(:unauthorized) }
      end
    end
  end

  def require_founder
    require_login
    if !current_user.has_role?(:founder)
      respond_to do |format|
        format.html { redirect_to main_app.signin_path, :notice => '您未被授权访问此页面!' }
        format.mobile { redirect_to main_app.signin_path, :notice => '您未被授权访问此页面!' }
        format.json { head(:unauthorized) }
      end
    end
  end

  def set_remember_me
    cookies.signed[:_remember_token] = {
      :httponly => true,
      :value => @current_user.remember_token,
      :expires => 2.weeks.from_now
    }
  end

end
