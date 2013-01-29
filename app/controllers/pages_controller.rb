# -*- encoding : utf-8 -*-
class PagesController < HighVoltage::PagesController
  caches_page :show
  layout :layout_for_page
  before_filter :set_page_title_and_breadcrumb

  protected
  def layout_for_page
    case params[:id]
    when 'about'
      'static'
    when '404'
      'errors'
    when 'errors'
      'errors'
    else
      'static'
    end
  end

  def set_page_title_and_breadcrumb
    case params[:id] 
    when 'about'
      @page_title = '关于我们'
      drop_breadcrumb(@page_title, static_page_path('about'))
    when 'help'
      @page_title = '帮助中心'
      drop_breadcrumb(@page_title, static_page_path('help'))  
    when 'contact'
      @page_title = '联系我们'
      drop_breadcrumb(@page_title, static_page_path('contact'))  
    end

  end

end
