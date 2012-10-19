# -*- encoding : utf-8 -*-
class AddItemsCountToCategoies < ActiveRecord::Migration
  def change
    add_column :categories, :items_count, :integer, :default => 0
  end
end
