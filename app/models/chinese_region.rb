# -*- encoding : utf-8 -*-
# == Schema Information
#
# Table name: chinese_regions
#
#  id         :integer          not null, primary key
#  code       :string(255)
#  name       :string(255)
#  level      :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class ChineseRegion < ActiveRecord::Base
  attr_accessible :code, :level, :name

  validates :code,
    :presence => true,
    :uniqueness => { :case_sensitive => false }

  validates :name, :presence => true
  validates :level, :presence => true

  has_many :items, :foreign_key => 'region_code'

  scope :provinces, select("code, name").where(:level => 1)
end
