# -*- encoding : utf-8 -*-
class HomeController < ApplicationController
  caches_action :index, :expires_in => 10.minutes, :layout => false
  caches_action :desktop, :expires_in => 10.minutes, :layout => false
  caches_action :search, :expires_in => 60.minutes, :layout => false

  def index
    @page_tiele = '首页'

    respond_to do |format|
      format.html { }
      format.mobile {
        @categories = Category.get_cached_all
      }
    end
  end

  def desktop
    @page_tiele = '图片广场'
    drop_breadcrumb(@page_tiele, desktop_path)

    @pictures = Picture.where({:imageable_type => 'Item'}).order( 'imageable_id desc' )

    respond_to do |wants|
      wants.html # index.html.erb
    end
  end

  def search 
    @page_title = '产品搜索'
    drop_breadcrumb('产品搜索', search_path)

    fresh_when 
  end

end
