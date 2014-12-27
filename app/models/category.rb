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
#  nid         :integer          default(0)
#  parent_id   :integer
#

# -*- encoding : utf-8 -*-
class Category < ActiveRecord::Base
  # extends ...................................................................
  has_closure_tree order: 'sort ASC'
  # includes ..................................................................
  # security (i.e. attr_accessible) ...........................................
  attr_accessible :name

  # validations ...............................................................
  validates :name,
    :presence => true,
    :uniqueness => { :case_sensitive => false }

  # callbacks .................................................................
  before_save { |category| category.slug = ::PinYin.permlink( category.name ) }



  # class methods .............................................................
  def self.get_cached_all
    categories = Rails.cache.fetch("global/categories/all}", expires_in: 60.minutes) do
      Category.all
    end
    categories
  end


  # public instance methods ...................................................
  def items
    Item.where('category_id = :category_id or category2_id = :category2_id',
               {category_id: self.id, category2_id: self.id}
              )
  end


  # protected instance methods ................................................
  # private instance methods ..................................................

end
