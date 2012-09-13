class User < ActiveRecord::Base
  attr_accessible :email, :cellphone, :password, :qq, :username, :password_confirmation
  has_secure_password

  validates_presence_of :password, :on => :create
  validates_uniqueness_of :email, case_sensitive: false
  validates_uniqueness_of :username, case_sensitive: false
  validates_uniqueness_of :cellphone
  validates_format_of :email, with: /\A[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,4}\z/i, allow_blank: true 
  validates_format_of :cellphone, :with => /1\d{10}/, allow_blank: true

  def self.authenticate_by_username(username, password)
    find_by_username(username).try(:authenticate, password)
  end
  def self.authenticate_by_email(email, password)
    find_by_email(emaill).try(:authenticate, password)
  end

  def self.authenticate_by_cellphone(cellphone, password)
    find_by_cellphone(cellphone).try(:authenticate, password)
  end
end
