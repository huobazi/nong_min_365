# -*- encoding : utf-8 -*-

class Category < ActiveRecord::Base
  attr_accessible :name

  validates :name,
    :presence => true,
    :uniqueness => { :case_sensitive => false }


  before_save { |category| category.slug = ::PinYin.permlink( category.name ) }

end
