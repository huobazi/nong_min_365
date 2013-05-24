# -*- encoding : utf-8 -*-
# == Schema Information
#
# Table name: pictures
#
#  id             :integer          not null, primary key
#  image          :string(255)
#  imageable_id   :integer
#  imageable_type :string(255)
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#

class Picture < ActiveRecord::Base

  attr_accessible :image, :image_cache

  mount_uploader :image, PictureUploader

  belongs_to :imageable, :polymorphic => true

  after_create  :set_item_primary_picture
  after_destroy :set_item_primary_picture_when_destroy

  def priamary?
    return false if self.imageable_type != 'Item'
    self.id == self.imageable.primary_picture_id
  end

  def set_to_priamary
    self.imageable.primary_picture_id = self.id
    self.imageable.save!
  end

  def set_item_primary_picture
    item = Item.find self.imageable_id
    if item.primary_picture_id.nil? or Picture.where(:id => item.primary_picture_id).empty?
      item.primary_picture_id = self.id
    end
    item.save!
  end

  def set_item_primary_picture_when_destroy
    item = Item.find self.imageable_id
    if item.primary_picture_id.nil? or item.primary_picture_id == self.id or Picture.where(:id => item.primary_picture_id).empty?
      pictures = item.pictures.where("id != #{self.id}").order('id desc')
      if pictures.empty?
        item.primary_picture_id = nil
      else
        item.primary_picture_id = pictures.first.id
      end
    end
    item.save!
  end

end

