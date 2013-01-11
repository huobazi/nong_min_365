# -*- encoding : utf-8 -*-
class FixItemsViewCountColumnName < ActiveRecord::Migration
  def up
    rename_column :items, :view_count, :visit_count
  end

  def down
    rename_column :items, :visit_count, :view_count 
  end
end
