# -*- encoding : utf-8 -*-
class HomeController < ApplicationController
  caches_action :index, :expires_in => 10.minutes, :layout => false
  caches_action :search, :expires_in => 60.minutes, :layout => false
  
  def index
    @page_tiele = '首页'
  end

  def search 
    @page_title = '产品搜索'
    drop_breadcrumb('产品搜索', search_path)

    fresh_when 
  end

end
