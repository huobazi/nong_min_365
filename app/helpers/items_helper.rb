# -*- encoding : utf-8 -*-
module ItemsHelper

  def build_items_list_condition_category_link(category_id, category_name)
    the_hash = {}
    category = @current_params[:category].to_i
    xtype    = @current_params[:xtype].to_i
    area     = @current_params[:area] || ''

    the_hash[:xtype]    = xtype if xtype > 0
    the_hash[:area]     = area if not area.empty?
    the_hash[:category] = category_id

    link_text           = category_name

    link_to link_text, condition_list_items_path(the_hash), :class => (category_id == category ? "current" : "" )
  end

  def build_items_list_condition_area_link(area_code, area_name)
    the_hash = {}
    category = @current_params[:category].to_i
    xtype    = @current_params[:xtype].to_i
    area     = @current_params[:area] || ''

    the_hash[:category] = category if category > 0
    the_hash[:xtype]    = xtype if xtype > 0
    the_hash[:area]     = area_code

    link_text           = area_name

    link_to link_text, condition_list_items_path(the_hash), :class => (area_code == area ? "current" : "" )
  end

  def build_items_list_condition_xtype_link(xtype_value, xtype_name)
    the_hash = {}
    category = @current_params[:category].to_i
    xtype    = @current_params[:xtype].to_i
    area     = @current_params[:area] || ''

    the_hash[:area]     = area if not area.empty?
    the_hash[:category] = category if category > 0
    the_hash[:xtype]    = xtype_value

    link_text           = xtype_name

    link_to link_text, condition_list_items_path(the_hash), :class => (xtype_value == xtype ? "current" : "" )
  end

  def build_items_list_condition_remove_category_path
    the_hash = {}
    area     = @current_params[:area] || ''
    xtype    = @current_params[:xtype].to_i

    the_hash[:area]     = area if not area.empty?
    the_hash[:xtype]    = xtype if xtype > 0
    the_hash[:category] = nil

    condition_list_items_path(the_hash)
  end

  def build_items_list_condition_remove_xtype_path
    the_hash    = {}
    area        = @current_params[:area] || ''
    category_id = @current_params[:category].to_i

    the_hash[:area]     = area if not area.empty?
    the_hash[:category] = category_id if category_id > 0
    the_hash[:xtype] = nil

    condition_list_items_path(the_hash)
  end

  def build_items_list_condition_remove_area_path(area_code)
    the_hash    = {}

    xtype       = @current_params[:xtype].to_i
    category_id = @current_params[:category].to_i
    ary         = ['0000000000', '00000000', '000000', '000']

    the_hash[:xtype]    = xtype if xtype > 0
    the_hash[:category] = category_id if category_id > 0
    the_hash[:area]     = nil

    level,prefix = ChineseRegion.get_level_and_prefix area_code
    if level == 1
      the_hash[:area] = nil
    elsif level == 2
      the_hash[:area] = prefix[0,2] + ary[0]
    elsif level == 3
      the_hash[:area] = prefix[0,4] + ary[1]
    elsif level == 4
      the_hash[:area] = prefix[0,6] + ary[2]
    else
      the_hash[:area] = prefix[0,9] + ary[3]
    end

    condition_list_items_path(the_hash)
  end

  def build_items_list_area_link(item)
    the_hash = {}
    category = @current_params[:category].to_i
    xtype    = @current_params[:xtype].to_i
    area     = @current_params[:area] || ''

    the_hash[:category] = category if category > 0
    the_hash[:xtype]    = xtype if xtype > 0

    if not area.empty?
      level, prefix = ChineseRegion.get_level_and_prefix area
      case level
      when 1
        the_hash[:area] = item.city_code
        link_text       = item.city_name
      when 2
        the_hash[:area] = item.county_code
        link_text       = item.county_name
      when 3
        the_hash[:area] = item.town_code
        link_text       = item.town_name
      when 4
        the_hash[:area] = item.village_code
        link_text       = item.village_name
      else
        the_hash[:area] = item.village_code
        link_text       = item.village_name
      end
    else
      the_hash[:area] = item.province_code
      link_text       = item.province_name
    end

    link_to link_text, condition_list_items_path(the_hash)
  end
end
