# -*- encoding : utf-8 -*-
class HomeController < ApplicationController
  caches_action :desktop, :expires_in => 10.minutes, :layout => false
  caches_action :search, :expires_in => 60.minutes, :layout => false

  def desktop
    @page_tiele = '广场'
    drop_breadcrumb(@page_tiele, desktop_path)

    respond_to do |format|
      format.html { }
      format.mobile {
        @categories = Category.get_cached_all
      }
    end
  end

  def index
    @page_tiele = '首页'
    page_size   = 9
    page_index  = params[:page]

    @items = Item.includes(:primary_picture).where('primary_picture_id > 0').order(' id desc ').page(page_index).per(page_size)

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
