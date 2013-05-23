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

  belongs_to :imageable, :polymorphic => true

  mount_uploader :image, PictureUploader

end
