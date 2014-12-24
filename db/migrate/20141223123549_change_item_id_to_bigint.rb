# -*- encoding : utf-8 -*-
class ChangeItemIdToBigint < ActiveRecord::Migration
  def up
    change_column :items, :id, :integer, limit: 8
    change_column :taggings, :taggable_id, :integer, limit: 8
    change_column :pictures, :imageable_id, :integer, limit: 8
  end

  def down
  end
end
