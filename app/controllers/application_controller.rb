# -*- encoding : utf-8 -*-
class ApplicationController < ActionController::Base
  include Mobylette::RespondToMobileRequests
  include SessionsHelper
  include ApplicationHelper

  protect_from_forgery

  before_filter :adjust_mobilejs_format_for_mobile_devise

  rescue_from CanCan::AccessDenied do |exception|
    require_login
  end

  #rescue_from Exception,                            :with => :render_500
  #rescue_from ActiveRecord::RecordNotFound,         :with => :render_404
  #rescue_from ActionController::RoutingError,       :with => :render_404
  #rescue_from ActionController::UnknownController,  :with => :render_404
  #rescue_from ActionController::UnknownAction,      :with => :render_404
  #rescue_from ActionView::MissingTemplate,          :with => :render_404

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
    opts[:etag] << SiteSettings.all
    opts[:etag] << SiteSettings.site_name
    opts[:etag] << SiteSettings.domain_name
    opts[:etag] << SiteSettings.google_account_id
    opts[:etag] << SiteSettings.google_search_uniq_id
    opts[:etag] << SiteSettings.google_api_key
    opts[:etag] << flash.notice
    opts[:etag] << Rails.application.assets.find_asset('application.js').digest_path
    #font-awasome.eot?iefix 这个路径会导致下面定有问题，等gem升级
    #opts[:etag] << Rails.application.assets.find_asset('application.css').digest_path

    # 加入通知数量
    #opts[:etag] << unread_notify_count

    # 所有 etag 保持一天
    opts[:etag] << Date.current
    opts[:etag] << Time.now if not Rails.env.production?
    super(opts)
  end

  def render_404(exception)
    render_optional_error_file 404, exception
  end

  def render_403(exception)
    render_optional_error_file 403, exception
  end

  def render_500(exception)
    render_optional_error_file 500, exception
  end

  private
  def adjust_mobilejs_format_for_mobile_devise
    if is_mobile_request? &&  request.accepts.include?("text/javascript")
      request.format = :mobilejs
    end
  end

  def render_optional_error_file(status_code, exception)
    if defined?(RAILS_ENV) and RAILS_ENV == 'development'
      return
    end
    status = status_code.to_s
    logger.error(exception)
    newrelic_notice_error(exception) if respond_to?(:newrelic_notice_error)

    if ["404","403", "422", "500"].include?(status)
      respond_to do |format|
        format.html do
          render :template => "/pages/errors/#{status}", :status => status, :layout => "errors"
        end
        format.any  do
          method = "to_#{request_format}"
          text = {}.respond_to?(method) ? {:error => 'server error'}.send(method) : ""
          render :text => text, :status => status
        end
      end
    else
      respond_to do |format|
        format.html do
          render :template => "/pages/errors/unknown", :handler => [:erb], :status => status, :layout => "errors"
        end
        format.any  do
          method = "to_#{request_format}"
          text = {}.respond_to?(method) ? {:error => 'server error'}.send(method) : ""
          render :text => text, :status => status
        end
      end
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

