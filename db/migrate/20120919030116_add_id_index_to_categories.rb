# -*- encoding : utf-8 -*-
class AddIdIndexToCategories < ActiveRecord::Migration
  def change
    add_index categories, :id
  end
end
