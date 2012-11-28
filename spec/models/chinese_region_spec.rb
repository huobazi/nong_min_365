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
