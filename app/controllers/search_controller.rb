# -*- encoding : utf-8 -*-
class SearchController < ApplicationController
  
  def index
    @page_title = '产品搜索'
    drop_breadcrumb('产品搜索', search_path)

    fresh_when 
    expires_in 1.hour 
  end

end
