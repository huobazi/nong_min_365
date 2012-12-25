# -*- encoding : utf-8 -*-
class HomeController < ApplicationController
  def index
    @page_tiele = '首页'
    @categories = Category.all
  end
end
