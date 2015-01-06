# -*- encoding : utf-8 -*-
# == Schema Information
#
# Table name: items
#
#  id                 :integer          not null, primary key
#  title              :string(255)
#  amount             :string(255)
#  xtype              :integer
#  province_code      :string(255)
#  contact_name       :string(255)
#  contact_phone      :string(255)
#  contact_qq         :string(255)
#  body               :text
#  category_id        :integer
#  user_id            :integer
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  city_code          :string(255)
#  county_code        :string(255)
#  town_code          :string(255)
#  village_code       :string(255)
#  province_name      :string(255)
#  city_name          :string(255)
#  county_name        :string(255)
#  town_name          :string(255)
#  village_name       :string(255)
#  ip                 :string(255)
#  visit_count        :integer          default(0)
#  slug               :string(255)
#  publis_status      :integer          default(0)
#  source             :string(255)
#  refresh_at         :integer          default(0)
#  primary_picture_id :integer
#

# -*- encoding : utf-8 -*-
class Item < ActiveRecord::Base
  include SnowFlakeAutoGenerateId
  # extends ...................................................................
  acts_as_taggable_on :tags

  # includes ..................................................................
  # security (i.e. attr_accessible) ...........................................
  attr_accessible :category_id, :category2_id, :amount, :body, :contact_name,
    :contact_phone, :contact_qq, :title, :xtype,
    :province_code, :city_code, :county_code, :town_code, :village_code,
    :tag_list, :refresh_at

  # relationships .............................................................
  belongs_to :category, :counter_cache => :items_count
  counter_culture :category, :column_name => "items_count"

  belongs_to :category2, class_name: 'Category',counter_cache: :items_count
  counter_culture :category2, :column_name => "items_count"

  belongs_to :user, :counter_cache => :items_count
  counter_culture :user, :column_name => "items_count"

  belongs_to :province , :class_name => 'ChineseRegion' , :foreign_key => 'province_code'
  belongs_to :city     , :class_name => 'ChineseRegion' , :foreign_key => 'city_code'
  belongs_to :county   , :class_name => 'ChineseRegion' , :foreign_key => 'county_code'
  belongs_to :town     , :class_name => 'ChineseRegion' , :foreign_key => 'town_code'
  belongs_to :village  , :class_name => 'ChineseRegion' , :foreign_key => 'village_code'


  counter_culture :category, :column_name => "province_items_count"
  counter_culture :category, :column_name => "city_items_count"
  counter_culture :category, :column_name => "county_items_count"
  counter_culture :category, :column_name => "town_items_count"
  counter_culture :category, :column_name => "village_items_count"

  has_many :pictures, :as => :imageable
  has_one  :primary_picture, :class_name => 'Picture', :primary_key => 'primary_picture_id', :foreign_key => 'id'

  # validations ...............................................................
  validates :title, :presence => true, :length => { :in => 3..30 }
  validates :amount, :presence => true
  validates :category_id, :presence => { :message => '必须选择' }
  validates :category2_id, :presence => { :message => '必须选择' }
  #validates :xtype, :presence => { :message => '必须选择' }
  validates :province_code, :presence => { :message => '必须选择' }
  validates :city_code, :presence => { :message => '必须选择' }
  validates :county_code, :presence => { :message => '必须选择' }
  validates :town_code, :presence => { :message => '必须选择' }
  validates :village_code, :presence => { :message => '必须选择' }
  validates :contact_name, :presence => true
  validates :contact_phone, :presence => true, :length => { :in => 7..20 }, :numericality => { :only_integer => true }
  validates :contact_qq, :presence => true, :length => { :in => 5..20 }, :numericality => { :only_integer => true }
  validates :body, :presence => true
  validates :tag_list, :presence => true

  # callbacks .................................................................
  before_save :populate_region_name,:fix_tags_name, :fix_refresh_at, :add_province_name_to_tags
  before_save { |item| item.slug = ::PinYin.permlink( item.title ) }

  # scopes ....................................................................
  scope :latest, order(' refresh_at DESC , id DESC ')

  # additional config .........................................................

  # class methods .............................................................

  # public instance methods ...................................................

  #def to_param
    #"#{id} #{slug}".parameterize
  #end

  def region_name
    [self.province_name, self.city_name, self.county_name, self.town_name, self.village_name].join(' | ')
  end

  # protected instance methods ................................................
  # private instance methods ..................................................
  private
  def populate_region_name
    self.province_name = self.province.name if self.province
    self.city_name     = self.city.name if self.city
    self.county_name   = self.county.name if self.county
    self.town_name     = self.town.name if self.town
    self.village_name  = self.village.name if self.village
  end
  def fix_tags_name
    # 全角逗号的处理
    self.tag_list = self.tag_list.join(',').gsub(/，/,',').gsub('.','')

    # 全角顿号的处理
    self.tag_list = self.tag_list.join(',').gsub(/、/,',')
  end
  def add_province_name_to_tags
    if not self.tag_list.include? "#{self.province_name}"
      self.tag_list.push self.province_name
    end
  end
  def fix_refresh_at
    self.refresh_at = Time.now.to_i
  end

end
