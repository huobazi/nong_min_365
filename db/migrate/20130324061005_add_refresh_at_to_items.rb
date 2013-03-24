class AddRefreshAtToItems < ActiveRecord::Migration
  def change
    add_column :items, :refresh_at, :integer, :default => 0 
    Item.all.each do |item|
      item.update_attributes!(:refresh_at => item.created_at.to_i)
    end
  end
end
