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

class Item < ActiveRecord::Base
  belongs_to :category, :counter_cache => :items_count
  belongs_to :user

  belongs_to :province , :class_name => 'ChineseRegion' , :foreign_key => 'province_code' , :inverse_of => :province_items , :counter_cache => :province_items_count
  belongs_to :city     , :class_name => 'ChineseRegion' , :foreign_key => 'city_code'     , :inverse_of => :city_items     , :counter_cache => 'city_items_count'
  belongs_to :county   , :class_name => 'ChineseRegion' , :foreign_key => 'county_code'   , :inverse_of => :county_items   , :counter_cache => 'county_items_count'
  belongs_to :town     , :class_name => 'ChineseRegion' , :foreign_key => 'town_code'     , :inverse_of => :town_items     , :counter_cache => 'town_items_count'
  belongs_to :village  , :class_name => 'ChineseRegion' , :foreign_key => 'village_code'  , :inverse_of => :village_items  , :counter_cache => 'village_items_count'


  attr_accessible :category_id, :amount, :body, :contact_name, 
    :contact_phone, :contact_qq, :password, :title, :xtype,
    :province_code, :city_code, :county_code, :town_code, :village_code

  validates :title, :presence => true, :length => { :in => 6..30 }
  validates :amount, :presence => true
  validates :category_id, :presence => { :message => '必须选择' }
  validates :xtype, :presence => { :message => '必须选择' }
  validates :province_code, :presence => true
  validates :city_code, :presence => true
  validates :county_code, :presence => true
  validates :town_code, :presence => true
  validates :village_code, :presence => true
  validates :contact_name, :presence => true
  validates :contact_phone, :presence => true, :length => { :in => 7..20 }, :numericality => { :only_integer => true }
  validates :contact_qq, :presence => true, :length => { :in => 5..20 }, :numericality => { :only_integer => true }
  validates :body, :presence => true
  validates :password, :presence => true, :length => { :in => 6..20 }, :if => :require_password?

  def require_password?
    user_id == 0
  end
end
