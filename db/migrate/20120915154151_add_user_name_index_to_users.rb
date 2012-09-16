# -*- encoding : utf-8 -*-
class AddUserNameIndexToUsers < ActiveRecord::Migration
  def change
    add_index :users, :username
  end
end
