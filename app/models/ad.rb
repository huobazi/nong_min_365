# -*- encoding : utf-8 -*-
# == Schema Information
#
# Table name: ads
#
#  id            :integer          not null, primary key
#  title         :string(255)
#  amount        :string(255)
#  xtype         :string(255)
#  region_code   :string(255)
#  contact_name  :string(255)
#  contact_phone :string(255)
#  contact_qq    :string(255)
#  body          :text
#  password      :string(255)
#  category_id   :integer
#  user_id       :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

class Ad < ActiveRecord::Base
  belongs_to :category
  belongs_to :user
  attr_accessible :amount, :body, :contact_name, :contact_phone, :contact_qq, :password, :title, :xtype, :region_code
end
