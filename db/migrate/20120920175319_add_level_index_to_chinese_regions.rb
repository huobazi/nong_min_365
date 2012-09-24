# -*- encoding : utf-8 -*-
class AddLevelIndexToChineseRegions < ActiveRecord::Migration
  def change
    add_index :chinese_regions, :level
  end
end
