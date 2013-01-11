# -*- encoding : utf-8 -*-
class SearchController < ApplicationController
  
  def index
    @page_tiele = '产品搜索'
    drop_breadcrumb('产品搜索', search_path)

    expires_in 1.hour 
    fresh_when(@page_tiele) 
  end

end
