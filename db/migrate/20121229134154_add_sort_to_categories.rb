# -*- encoding : utf-8 -*-
class AddSortToCategories < ActiveRecord::Migration
  def change
    add_column :categories, :sort, :integer, :default => 0
  end
end
