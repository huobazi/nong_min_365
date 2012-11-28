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
