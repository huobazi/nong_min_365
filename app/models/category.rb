# -*- encoding : utf-8 -*-
# == Schema Information
#
# Table name: categories
#
#  id          :integer          not null, primary key
#  name        :string(255)
#  slug        :string(255)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  items_count :integer          default(0)
#  sort        :integer          default(0)
#

# -*- encoding : utf-8 -*-
class Category < ActiveRecord::Base
  attr_accessible :name
  
  default_scope order('sort ASC')

  validates :name,
    :presence => true,
    :uniqueness => { :case_sensitive => false }

  before_save { |category| category.slug = ::PinYin.permlink( category.name ) }

  has_many :items

  def self.get_cached_all
    categories = Rails.cache.fetch("global/categories/all}", expires_in: 60.minutes) do
      Category.all  
    end
    categories
  end

end
