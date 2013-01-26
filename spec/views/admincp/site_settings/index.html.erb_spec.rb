require 'spec_helper'

describe "admincp/site_settings/index" do
  before(:each) do
    assign(:admincp_site_settings, [
      stub_model(Admincp::SiteSetting),
      stub_model(Admincp::SiteSetting)
    ])
  end

  it "renders a list of admincp/site_settings" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
  end
end
