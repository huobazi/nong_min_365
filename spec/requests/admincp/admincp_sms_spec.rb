# -*- encoding : utf-8 -*-
require 'spec_helper'

describe "Admincp::Sms" do
  describe "GET /admincp_sms" do
    it "works! (now write some real specs)" do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      get admincp_sms_path
      response.status.should be(200)
    end
  end
end
