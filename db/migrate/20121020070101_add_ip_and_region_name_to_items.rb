# -*- encoding : utf-8 -*-
class AddIpAndRegionNameToItems < ActiveRecord::Migration
  def change
    add_column :items, :province_name, :string
    add_column :items, :city_name, :string
    add_column :items, :county_name, :string
    add_column :items, :town_name, :string
    add_column :items, :village_name, :string
    add_column :items, :ip, :string
  end
end
