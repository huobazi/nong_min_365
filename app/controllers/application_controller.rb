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
      mobile: [:mobile, :html]
    }
  end

  private 

  def adjust_mobilejs_format_for_mobile_devise
    if is_mobile_request? &&  request.accepts.include?("text/javascript")
      request.format = :mobilejs
    end
  end
end

module BootstrapHelper
    module Breadcrumb
        module InstanceMethods
            protected
            def set_breadcrumbs
                @breadcrumbs = ["<a href='/'><i class = 'icon-home'></i>首页</a>".html_safe]
            end
        end
    end
end
