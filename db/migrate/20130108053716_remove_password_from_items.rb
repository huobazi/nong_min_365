# -*- encoding : utf-8 -*-
class RemovePasswordFromItems < ActiveRecord::Migration
  def up
    remove_column :items, :password
  end

  def down
    remove_column :items, :password, :string
  end
end
