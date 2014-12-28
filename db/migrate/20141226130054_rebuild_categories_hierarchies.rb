class RebuildCategoriesHierarchies < ActiveRecord::Migration
  def up
    Category.rebuild!
  end

  def down
  end
end
