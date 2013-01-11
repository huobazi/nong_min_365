# -*- encoding : utf-8 -*-
class AjaxController < ApplicationController
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
end
