# -*- encoding : utf-8 -*-
class ApplicationController < ActionController::Base
  include Mobylette::RespondToMobileRequests
  include SessionsHelper
  include ApplicationHelper

  protect_from_forgery

  before_filter :adjust_mobilejs_format_for_mobile_devise

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_url, :alert => exception.message
  end
  #mobilette config
  mobylette_config do |config|
    config[:skip_xhr_requests] = false
    config[:skip_user_agents] = [:ipad]
    config[:fallback_chains] = {
      mobile: [:mobile, :html]
    }
  end

  def fresh_when(opts = {})
    opts[:etag] ||= []

    # 保证 etag 参数是 Array 类型
    opts[:etag] = [opts[:etag]] if !opts[:etag].is_a?(Array)

    # 加入页面上直接调用的信息用于组合 etag
    opts[:etag] << current_user
    opts[:etag] << @page_title 

    # Config 的某些信息
    opts[:etag] << google_account_id
    opts[:etag] << google_api_key
    opts[:etag] << flash.notice

    # 加入通知数量
    #opts[:etag] << unread_notify_count

    # 所有 etag 保持一天
    opts[:etag] << Date.current
    super(opts)
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
