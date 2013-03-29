# -*- encoding : utf-8 -*-
class MailMessage
# extends ...................................................................
  # includes ..................................................................
  include ActiveModel::Conversion
  include ActiveModel::Validations

  # security (i.e. attr_accessible) ...........................................
  attr_accessor :name, :email, :subject, :body

  # relationships .............................................................
  # validations ...............................................................
  validates :name,    :presence => false 
  validates :email,   :format => { :with => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i },:allow_blank => true
  validates :subject, :presence => true 
  validates :body, :presence => true

  # callbacks .................................................................
  # scopes ....................................................................
  # additional config .........................................................
  # class methods .............................................................
  # public instance methods ...................................................
  def initialize(attributes = {})
    attributes.each do |key, value|
      send("#{key}=", value)
    end
  end

  def save
    if self.valid?
      return true
    end
    return false
  end

  def persisted?
    false
  end

  # protected instance methods ................................................
  # private instance methods ..................................................

end
