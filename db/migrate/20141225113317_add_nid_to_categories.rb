class AddNidToCategories < ActiveRecord::Migration
  def change
    add_column :categories, :nid, :integer, default: 0
  end
end
