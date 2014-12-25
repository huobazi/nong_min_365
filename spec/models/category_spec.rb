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
require 'spec_helper'

describe Category do
  context "model" do
    #before (:each) do
    #create(:category)
    #end

    it {should validate_presence_of :name}

    it {should have_many(:items)}

  end 
end
