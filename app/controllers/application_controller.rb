# -*- encoding : utf-8 -*-
class ApplicationController < ActionController::Base
  include Mobylette::RespondToMobileRequests
  include SessionsHelper

  protect_from_forgery

  before_filter :adjust_mobilejs_format_for_mobile_devise

  #mobilette config
  mobylette_config do |config|
    config[:skip_xhr_requests] = false
    config[:skip_user_agents] = [:ipad]
    config[:fallback_chains] = {
      mobile: [:mobile, :html],
      iphone: [:iphone, :mobile, :html],
      android: [:android, :mobile, :html]
    }
  end

  private 

  def adjust_mobilejs_format_for_mobile_devise
    if is_mobile_request? &&  request.accepts.include?("text/javascript")
      request.format = :mobilejs
    end
  end

end
