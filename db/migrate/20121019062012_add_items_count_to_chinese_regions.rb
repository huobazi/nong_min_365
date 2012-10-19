# -*- encoding : utf-8 -*-
class AddItemsCountToChineseRegions < ActiveRecord::Migration
  def change
    add_column :chinese_regions, :province_items_count, :integer, :default => 0
    add_column :chinese_regions, :city_items_count, :integer, :default => 0
    add_column :chinese_regions, :county_items_count, :integer, :default => 0
    add_column :chinese_regions, :town_items_count, :integer, :default => 0
    add_column :chinese_regions, :village_items_count, :integer, :default => 0
  end
end
