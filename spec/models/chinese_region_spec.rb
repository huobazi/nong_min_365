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

# -*- encoding : utf-8 -*-
require "spec_helper"

describe ChineseRegion do
  context "model" do
    it {should validate_presence_of :name}
    it {should validate_presence_of :code}
    it {should validate_presence_of :level}

    it {should have_many :province_items}
    it {should have_many :city_items}
    it {should have_many :county_items}
    it {should have_many :town_items}
    it {should have_many :village_items}
  end
end
