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
  CODE_LENGTH = 12

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

  def self.get_cached_all_province
    regions = Rails.cache.fetch("global/regions/provinces/all}", expires_in: 360.minutes) do
      ChineseRegion.provinces 
    end
    regions
  end
  def self.get_level_and_prefix(code)
    ary = ['nil', '0000000000', '00000000', '000000', '000']
    if code.end_with? ary[1] 
      level = 1
      code_prefix = code.chomp(ary[1])
    elsif code.end_with? ary[2] 
      level = 2 
      code_prefix = code.chomp(ary[2])
    elsif code.end_with? ary[3] 
      level = 3
      code_prefix = code.chomp(ary[3])
    elsif code.end_with? ary[4]
      level = 4
      code_prefix = code.chomp(ary[4])
    else
      level = 5
      code_prefix = code
    end

    return level,code_prefix
  end

  def self.children(code)
    level, prefix = self.get_level_and_prefix(code)
    code_like = "#{prefix}%"
    children_level = level + 1

    if level <= 5
      regions = Rails.cache.fetch("global/regions/#{code}/children", expires_in: 24*60.minutes) do
        self.select('code, name').where(
          "level = :level and code like :code_like", 
          {:level => children_level, :code_like => code_like}
        )
      end
    end

    return children_level,regions
  end

  def self.get_parents(code)
    ary = ['0000000000', '00000000', '000000', '000']
    level, prefix = self.get_level_and_prefix(code)
    id_ary = []

    ( 0 .. (level - 1) ).each do |index|
      id_ary[index] = prefix[0,2] + ary[0] if index == 0
      id_ary[index] = prefix[0,4] + ary[1] if index == 1
      id_ary[index] = prefix[0,6] + ary[2] if index == 2
      id_ary[index] = prefix[0,9] + ary[3] if index == 3
      id_ary[index] = code if index == 4
    end

    regions = Rails.cache.fetch("global/regions/#{code}/parents", expires_in: 24*60.minutes) do
      self.select('code, name, level').where(:code => id_ary).order(:level)
    end

    return regions
  end

end
