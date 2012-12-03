# -*- encoding : utf-8 -*-
class HomeController < ApplicationController
  def index
    @categories = Category.all
  end
end
