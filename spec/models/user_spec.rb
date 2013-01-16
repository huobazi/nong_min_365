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
#  items_count     :integer          default(0)
#

# -*- encoding : utf-8 -*-
require "spec_helper"

describe User do
  context "model" do
    it {should validate_presence_of :username}
    it {should validate_presence_of :password}
    
    it {should have_many :items}
  end
end
