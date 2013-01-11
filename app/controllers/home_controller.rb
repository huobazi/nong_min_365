# -*- encoding : utf-8 -*-
class HomeController < ApplicationController
  caches_action :index, :expires_in => 10.minutes, :layout => false
  
  def index
    @page_tiele = '首页'
    @categories = Category.all
    
    #expires_in 10.minutes
    fresh_when(:etag => [@categories]) 
  end
end
