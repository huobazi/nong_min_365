# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  username               :string(255)
#  email                  :string(255)
#  password_digest        :string(255)
#  cellphone              :string(255)
#  qq                     :string(255)
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  remember_token         :string(255)
#  items_count            :integer          default(0)
#  password_reset_token   :string(255)
#  password_reset_sent_at :datetime
#

# -*- encoding : utf-8 -*-
class User < ActiveRecord::Base
  # extends ...................................................................
  has_secure_password

  # includes ..................................................................
  # security (i.e. attr_accessible) ...........................................
  attr_accessor :current_password
  attr_accessible  :username, :email, :qq, :cellphone, :password, :password_confirmation, :current_password

  # relationships .............................................................
  has_many :items, :order => ' id desc '

  # validations ...............................................................
  validates :username,
    :uniqueness => { :case_sensitive => false },
    :length => { :in => 6..20 }
  validates_presence_of :username, :on => :create

  validates :password, :length => { :in => 6..36 }, :if => :password_required?
  validates_presence_of :password, :if => :password_required?
  validates_confirmation_of :password, :if => :password_required?

  validates_presence_of   :email, :if => :email_required?
  validates_uniqueness_of :email, :allow_blank => true, :if => :email_changed?
  validates_format_of     :email, :with  => /\A[^@]+@([^@\.]+\.)+[^@\.]+\z/, :allow_blank => true, :if => :email_changed?

  validates :cellphone,
    :uniqueness => true,
    :length => { :is => 11 },
    :numericality => { :only_integer => true },
    :allow_blank => true

  validates :qq,
    :length => { :in => 5..20 },
    :numericality => { :only_integer => true },
    :allow_blank => true

  # callbacks .................................................................
  before_create { generate_token(:remember_token) }
  before_save { |user| user.email = email.downcase if email && email.size > 0 }

  # scopes ....................................................................
  # additional config .........................................................
  # class methods .............................................................
  def self.authenticate_by_username(username, password)
    find_by_username(username).try(:authenticate, password)
  end

  def self.authenticate_by_email(email, password)
    find_by_email(emaill).try(:authenticate, password)
  end

  def self.authenticate_by_cellphone(cellphone, password)
    find_by_cellphone(cellphone).try(:authenticate, password)
  end

  # public instance methods ...................................................
  def send_password_resets
    generate_token(:password_reset_token)
    self.password_reset_sent_at = Time.zone.now
    self.save!
    NotificationsMailer.password_reset_mail(self).deliver
  end

  def has_role?(role)
    case role
    when :founder then founder?
    when :admin   then admin?
    when :member  then member?
    else
      false
    end
  end

  def generate_token(column)
    begin
      self[column] = SecureRandom.urlsafe_base64
    end while User.exists?(column => self[column])
  end

  # protected instance methods ................................................
  # private instance methods ..................................................
  private
  def founder?
    self.username == 'huobazi' && self.email == 'huobazi@gmail.com'
  end

  def admin?
    SiteSettings.admin_emails.include? self.email
  end

  def member?
    self.id > 0
  end

  def password_required? # copy from devise
    !persisted? || !password.nil? || !password_confirmation.nil?
  end

  def email_required?
    false
  end
end
