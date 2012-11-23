# -*- encoding : utf-8 -*-
class AddXtypeIndexToItems < ActiveRecord::Migration
  def change
    add_index :items, :xtype
  end
end
