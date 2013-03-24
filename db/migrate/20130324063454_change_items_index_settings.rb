class ChangeItemsIndexSettings < ActiveRecord::Migration
  def change 
    remove_index :items, :province_code
    remove_index :items, :city_code
    remove_index :items, :county_code
    remove_index :items, :town_code
    remove_index :items, :village_code
    remove_index :items, :user_id
    remove_index :items, :category_id
    remove_index :items, :xtype
    add_index :items, [:category_id, :refresh_at, :user_id, :province_code, :city_code, :county_code, :town_code, :village_code, :xtype], :name => 'index_on_items'
  end
end
