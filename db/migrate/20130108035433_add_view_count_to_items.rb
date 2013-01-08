# -*- encoding : utf-8 -*-
class AddViewCountToItems < ActiveRecord::Migration
  def change
    add_column :items, :view_count, :integer, :default => 0
  end
end
