# -*- encoding : utf-8 -*-
class AddRememberTokenToUsers < ActiveRecord::Migration
  def change
    add_column :users, :remember_token, :string
  end
end
