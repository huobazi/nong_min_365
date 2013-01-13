# -*- encoding : utf-8 -*-
class AddSlugToItems < ActiveRecord::Migration
  def change
    add_column :items, :slug, :string
  end
end
