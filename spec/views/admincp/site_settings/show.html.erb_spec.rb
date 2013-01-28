# -*- encoding : utf-8 -*-
require 'spec_helper'

describe "admincp/site_settings/show" do
  before(:each) do
    @site_setting = assign(:site_setting, stub_model(Admincp::SiteSetting))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
  end
end
