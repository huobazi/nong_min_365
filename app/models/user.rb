# -*- encoding : utf-8 -*-
# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  username        :string(255)
#  email           :string(255)
#  password_digest :string(255)
#  cellphone       :string(255)
#  qq              :string(255)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  remember_token  :string(255)
#

# -*- encoding : utf-8 -*-
class User < ActiveRecord::Base

  attr_accessor :current_password
  attr_accessible  :username, :email, :qq, :cellphone, :password, :password_confirmation, :current_password
  has_secure_password

  before_create { generate_token(:remember_token) }
  before_save { |user| user.email = email.downcase if email && email.size > 0 }

  validates :username, 
    :presence => true ,
    :uniqueness => { :case_sensitive => false },
    :length => { :in => 3..20 }

  validates :password, 
    :presence => true, 
    :length => { :in => 6..36 },
    :confirmation => true 

  validates :password_confirmation, :presence => true
  validates :current_password, :presence => true, :on => :update_password

  validates :email, 
    :uniqueness => { :case_sensitive => false },
    :length => { :in => 3..254 },
    :format => { :with => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i },
    :allow_blank => true

  validates :cellphone,
    :uniqueness => true,
    :length => { :is => 13 },
    :numericality => { :only_integer => true },
    :allow_blank => true

  validates :qq,
    :length => { :in => 5..20 }, 
    :numericality => { :only_integer => true },
    :allow_blank => true

  #def update_with_password(params, *options)
    #params.delete(:current_password)
    #super(params)
  #end

  #def update_without_password(params={})
    #params.delete(:current_password)
    #super(params)
  #end

  def self.authenticate_by_username(username, password)
    find_by_username(username).try(:authenticate, password)
  end
  
  def self.authenticate_by_email(email, password)
    find_by_email(emaill).try(:authenticate, password)
  end

  def self.authenticate_by_cellphone(cellphone, password)
    find_by_cellphone(cellphone).try(:authenticate, password)
  end

  protected
  def generate_token(column)
    begin
      self[column] = SecureRandom.urlsafe_base64
    end while User.exists?(column => self[column])
  end
end
