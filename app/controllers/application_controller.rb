# -*- encoding : utf-8 -*-
class ApplicationController < ActionController::Base
  protect_from_forgery
  include SessionsHelper
  include Mobylette::RespondToMobileRequests


  #mobilette config
  mobylette_config do |config|
    config[:skip_xhr_requests] = false
  end
end
