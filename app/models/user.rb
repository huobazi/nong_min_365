class User < ActiveRecord::Base
  attr_accessible :email, :cellphone, :password, :qq, :username, :password_confirmation
  has_secure_password

  validates :username, 
    :presence =>true ,
    :uniqueness => { :case_sensitive => false }
    :case_sensitive => false, 
    :length => { :in=> 6..20 }

  validates :password, 
    :presence => true, 
    :length => { :in=> 6..36 },
    :confirmation => true, 

  validates :email, 
    :uniqueness => true,
    :uniqueness => { :case_sensitive => false },
    :case_sensitive => false, 
    :length => { :in=> 3..254 },
    :format => { :with => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i },
    :allow_blank => true

  validates :cellphone,
    :uniqueness => true,
    :length => { :is => 13 },
    :numericality => { :only_integer => true },
    :allow_blank => true


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