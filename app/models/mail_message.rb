class MailMessage
  include ActiveModel::Conversion
  include ActiveModel::Validations

  attr_accessor :name, :email, :subject, :body

  validates :name,    :presence => false 
  validates :email,   :format => { :with => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i },:allow_blank => true
  validates :subject, :presence => true 
  validates :body, :presence => true

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
end
