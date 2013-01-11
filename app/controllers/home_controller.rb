# -*- encoding : utf-8 -*-
class HomeController < ApplicationController
  caches_action :index, :expires_in => 10.minutes, :layout => false
  
  def index
    @page_tiele = '首页'
  end
end
