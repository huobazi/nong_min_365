# -*- encoding : utf-8 -*-
class AdminConstraint
  def matches?(request)
    true
    #return false unless (request.session[:user_id] || request.cookie_jar.signed[:_remember_token])

    #current_user = ( User.find(request.session[:user_id]) if request.session[:user_id] ) 
    #if current_user
      #current_user = ( User.find_by_remember_token(request.cookie_jar.signed[:_remember_token]) if request.cookie_jar.signed[:_remember_token] )
      #request.session[:user_id] = current_user.id  if current_user
    #end

    #current_user && (current_user.is_founder? || current_user.is_admin?)
  end
end
