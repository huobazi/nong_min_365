# -*- encoding : utf-8 -*-
class AddRefreshAtToItems < ActiveRecord::Migration
  def change
    add_column :items, :refresh_at, :integer, :default => 0 
    #Item.all.each do |item|
      #item.update_attributes!(:refresh_at => item.created_at.to_i)
    #end
    execute <<-SQL
      update items set refresh_at = extract ( epoch from created_at )
    SQL

  end
end
