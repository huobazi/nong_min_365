require 'spec_helper'

describe "admincp/site_settings/show" do
  before(:each) do
    @admincp_site_setting = assign(:admincp_site_setting, stub_model(Admincp::SiteSetting))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
  end
end
