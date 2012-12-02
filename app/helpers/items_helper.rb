# -*- encoding : utf-8 -*-
module ItemsHelper
  def build_items_list_condition_category_link(category_id, category_name)
    the_hash = {}
    category = params[:category].to_i
    xtype = params[:xtype].to_i
    area = params[:area] || ''

    the_hash[:xtype] = xtype if xtype > 0
    the_hash[:area] = area if not area.empty?

    the_hash[:category] = category_id 
    link_text = category_name

    link_to link_text, items_path(the_hash)
  end

  def build_items_list_condition_area_link(area_code, area_name)
    the_hash = {}
    category = params[:category].to_i
    xtype = params[:xtype].to_i
    area = params[:area] || ''

    the_hash[:category] = category if category > 0
    the_hash[:xtype] = xtype if xtype > 0

    the_hash[:area] = area_code 
    link_text = area_name

    link_to link_text, items_path(the_hash)
  end

  def build_items_list_condition_xtype_link(xtype_value, xtype_name)
    the_hash = {}
    category = params[:category].to_i
    xtype = params[:xtype].to_i
    area = params[:area] || ''

    the_hash[:category] = category if category > 0
    the_hash[:area] = area if not area.empty?

    the_hash[:xtype] = xtype_value 
    link_text = xtype_name

    link_to link_text, items_path(the_hash)
  end


  def build_items_list_area_link(item)
    the_hash = {}
    category = params[:category].to_i
    xtype = params[:xtype].to_i
    area = params[:area] || ''

    the_hash[:category] = category if category > 0
    the_hash[:xtype] = xtype if xtype > 0

    if not area.empty?
      level,prefix = ChineseRegion.get_level_and_prefix area
      case level
      when 1
        the_hash[:area] = item.city_code
        link_text = item.city_name
      when 2
        the_hash[:area] = item.county_code
        link_text = item.county_name
      when 3
        the_hash[:area] = item.town_code
        link_text = item.town_name
      when 4
        the_hash[:area] = item.village_code
        link_text = item.village_name
      else
        the_hash[:area] = item.village_code
        link_text = item.village_name
      end  
    else
      the_hash[:area] = item.province_code
      link_text = item.province_name
    end  

    link_to link_text, items_path(the_hash)
  end
end
