# -*- encoding : utf-8 -*-
class AddSortIndexToCategories < ActiveRecord::Migration
  def change
    add_index :categories, :sort
  end
end
