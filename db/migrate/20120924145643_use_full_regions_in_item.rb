# -*- encoding : utf-8 -*-
class UseFullRegionsInItem < ActiveRecord::Migration
  def change 
    rename_column :items, :region_code, :province_code

    add_column :items,:city_code, :string
    add_column :items,:county_code, :string
    add_column :items,:town_code, :string
    add_column :items,:village_code, :string

    add_index :items, :province_code
    add_index :items, :city_code
    add_index :items, :county_code
    add_index :items, :town_code
    add_index :items, :village_code
  end

  #def down
    #rename_column :items, :province_code, :region_code
    #remove_column :items, :city_code
    #remove_column :items, :county_code
    #remove_column :items, :town_code
    #remove_column :items, :village_code
  #end

end
