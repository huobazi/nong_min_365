# -*- encoding : utf-8 -*-
# == Schema Information
#
# Table name: chinese_regions
#
#  id                   :integer          not null
#  code                 :string(255)      primary key
#  name                 :string(255)
#  level                :integer
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  province_items_count :integer          default(0)
#  city_items_count     :integer          default(0)
#  county_items_count   :integer          default(0)
#  town_items_count     :integer          default(0)
#  village_items_count  :integer          default(0)
#

class ChineseRegion < ActiveRecord::Base
  self.primary_key = 'code'

  attr_accessible :code, :level, :name

  validates :code,
    :presence => true,
    :uniqueness => { :case_sensitive => false }

  validates :name  , :presence => true
  validates :level , :presence => true

  has_many :province_items , :class_name => 'Item' , :foreign_key => 'province_code' , :inverse_of => :province
  has_many :city_items     , :class_name => 'Item' , :foreign_key => 'city_code'     , :inverse_of => :city
  has_many :county_items   , :class_name => 'Item' , :foreign_key => 'county_code'   , :inverse_of => :county
  has_many :town_items     , :class_name => 'Item' , :foreign_key => 'town_code'     , :inverse_of => :town
  has_many :village_items  , :class_name => 'Item' , :foreign_key => 'village_code'  , :inverse_of => :village

  scope :provinces, select('code, name').where(:level => 1)
end
