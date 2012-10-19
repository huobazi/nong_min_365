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
#

class Category < ActiveRecord::Base
  attr_accessible :name

  validates :name,
    :presence => true,
    :uniqueness => { :case_sensitive => false }

  before_save { |category| category.slug = ::PinYin.permlink( category.name ) }

  has_many :items
end
