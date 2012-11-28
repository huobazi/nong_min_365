# -*- encoding : utf-8 -*-
require "spec_helper"

describe User do
  context "model" do
    it {should validate_presence_of :username}
    it {should validate_presence_of :password}
  end
end
