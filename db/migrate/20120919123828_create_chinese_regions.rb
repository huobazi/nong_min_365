# -*- encoding : utf-8 -*-
class CreateChineseRegions < ActiveRecord::Migration
  def change
    create_table :chinese_regions do |t|
      t.string :code
      t.string :name
      t.integer :level

      t.timestamps
    end
    add_index :chinese_regions, :code
  end
end
