# -*- encoding : utf-8 -*-
class CreateAds < ActiveRecord::Migration
  def change
    create_table :items do |t|
      t.string :title
      t.string :amount
      t.string :xtype
      t.string :region_code
      t.string :contact_name
      t.string :contact_phone
      t.string :contact_qq
      t.text :body
      t.string :password
      t.references :category
      t.references :user

      t.timestamps
    end
    add_index :items, :category_id
    add_index :items, :user_id
    add_index :items, :region_code
  end
end
