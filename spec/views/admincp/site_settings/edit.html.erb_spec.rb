require 'spec_helper'

describe "admincp/site_settings/edit" do
  before(:each) do
    @admincp_site_setting = assign(:admincp_site_setting, stub_model(Admincp::SiteSetting))
  end

  it "renders the edit admincp_site_setting form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => admincp_site_settings_path(@admincp_site_setting), :method => "post" do
    end
  end
end
