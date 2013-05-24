class AddPrimaryPictureIdToItems < ActiveRecord::Migration
  def change
    add_column :items, :primary_picture_id, :integer
  end
end
