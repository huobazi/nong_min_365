# -*- encoding : utf-8 -*-
class HomeController < ApplicationController
  caches_action :desktop, :expires_in => 10.minutes, :layout => false
  caches_action :search, :expires_in => 60.minutes, :layout => false

  def desktop
    @page_tiele = '广场'
    drop_breadcrumb(@page_tiele, desktop_path)

    respond_to do |format|
      format.html
      format.mobile{@categories = Category.roots}
    end
  end

  def index
    @page_tiele = '首页'
    page_size   = 16
    page_index  = params[:page]

    require 'item'
    require 'picture'

    respond_to do |format|
      format.html{
        @items = Item.latest.includes(:primary_picture).where('primary_picture_id > 0').page(page_index).per(page_size)
      }
      format.mobile {
        redirect_to desktop_path
      }
    end
  end

  def search
    @page_title = '产品搜索'
    drop_breadcrumb('产品搜索', search_path)

    fresh_when 
  end

end
