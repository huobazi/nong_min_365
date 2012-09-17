# -*- encoding : utf-8 -*-
class AddIdIndexToUsers < ActiveRecord::Migration
  def change
    add_index :users, :id
  end
end
