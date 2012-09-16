# -*- encoding : utf-8 -*-
class AddIndexToUsers < ActiveRecord::Migration
  def change
    add_index :users, :remember_token
  end
end
