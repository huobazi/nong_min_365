# == Schema Information
#
# Table name: items
#
#  id            :integer          not null, primary key
#  title         :string(255)
#  amount        :string(255)
#  xtype         :integer
#  province_code :string(255)
#  contact_name  :string(255)
#  contact_phone :string(255)
#  contact_qq    :string(255)
#  body          :text
#  category_id   :integer
#  user_id       :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  city_code     :string(255)
#  county_code   :string(255)
#  town_code     :string(255)
#  village_code  :string(255)
#  province_name :string(255)
#  city_name     :string(255)
#  county_name   :string(255)
#  town_name     :string(255)
#  village_name  :string(255)
#  ip            :string(255)
#  visit_count   :integer          default(0)
#

# -*- encoding : utf-8 -*-
# -*- encoding : utf-8 -*-
# -*- encoding : utf-8 -*-
# -*- encoding : utf-8 -*-
require "spec_helper"

describe Item do
  context "model" do
    it {should validate_presence_of :title}
    it {should validate_presence_of :amount}
    it {should validate_presence_of :city_code}
    it {should validate_presence_of :county_code}
    it {should validate_presence_of :town_code}
    it {should validate_presence_of :village_code}
    it {should validate_presence_of :contact_name}
    it {should validate_presence_of :contact_phone}
    it {should validate_presence_of :contact_qq}
    it {should validate_presence_of :body}
    
    it {should belong_to :category}
    it {should belong_to :user}
    it {should belong_to :province}
    it {should belong_to :city}
    it {should belong_to :county}
    it {should belong_to :town}
    it {should belong_to :village}
  end
end
