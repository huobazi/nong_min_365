# -*- encoding : utf-8 -*-
class AjaxController < ApplicationController
  before_filter :require_login, :only => [:regions, :categories]

  def regions

    column_ary = ['nil', 'province_code', 'city_code',
                  'county_code', 'town_code', 'village_code']

    code        = params[:code]
    @parent_id  = params[:parent_id]
    @parent_css = params[:css]

    @children_level,@regions = ChineseRegion.children(code)

    @client_element_id = "item_#{column_ary[@children_level]}"
    @client_element_name = "item[#{column_ary[@children_level]}]"

    fresh_when(:etag => [code, @parent_id, @parent_css])

    respond_to do |format|
      format.js { render :layout => false }
      format.mobilejs { render :layout => false }
    end
  end

  def categories
    column_ary = [nil, 'category_id', 'category2_id']

    id = params[:id]
    @parent_id  = params[:parent_id]
    @parent_css = params[:css]

    category = Category.find(id)
    @categories = category.children
    @children_level = category.depth + 1 + 1

    @client_element_id = "item_#{column_ary[@children_level]}"
    @client_element_name = "item[#{column_ary[@children_level]}]"

    fresh_when(:etag => [id, @parent_id, @parent_css])

    respond_to do |format|
      format.js { render :layout => false }
      format.mobilejs { render :layout => false }
    end

  end
end
