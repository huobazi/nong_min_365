# -*- encoding : utf-8 -*-
class HomeController < ApplicationController
  caches_action :index, :expires_in => 20.minutes, :layout => false
  
  def index
    @page_tiele = '首页'
    @categories = Category.all
  end
end
