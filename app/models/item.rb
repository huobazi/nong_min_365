# -*- encoding : utf-8 -*-
# == Schema Information
#
# Table name: items
#
#  id            :integer          not null, primary key
#  title         :string(255)
#  amount        :string(255)
#  xtype         :string(255)
#  province_code :string(255)
#  contact_name  :string(255)
#  contact_phone :string(255)
#  contact_qq    :string(255)
#  body          :text
#  password      :string(255)
#  category_id   :integer
#  user_id       :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  city_code     :string(255)
#  county_code   :string(255)
#  town_code     :string(255)
#  village_code  :string(255)
#

# -*- encoding : utf-8 -*-
class Item < ActiveRecord::Base
  belongs_to :category
  belongs_to :user
  belongs_to :region, :class_name => 'ChineseRegion', :foreign_key => 'region_code'
  attr_accessible :category_id, :amount, :body, :contact_name, :contact_phone, :contact_qq, :password, :title, :xtype, :region_code

  validates :title, :presence => true, :length => { :in => 6..30 }
  validates :amount, :presence => true
  validates :category_id, :presence => { :message => '必须选择' }
  validates :xtype, :presence => { :message => '必须选择' }
  validates :region_code, :presence => true
  validates :contact_name, :presence => true
  validates :contact_phone, :presence => true, :length => { :in => 7..20 }, :numericality => { :only_integer => true }
  validates :contact_qq, :presence => true, :length => { :in => 5..20 }, :numericality => { :only_integer => true }
  validates :body, :presence => true
  validates :password, :presence => true, :length => { :in => 6..20 }, :if => :require_password?

  def require_password?
    user_id == 0
  end
end
