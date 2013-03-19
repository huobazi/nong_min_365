# -*- encoding : utf-8 -*-
require 'spec_helper'

describe "admincp/sms/new" do
  before(:each) do
    assign(:admincp_sm, stub_model(Admincp::Sm).as_new_record)
  end

  it "renders new admincp_sm form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => admincp_sms_path, :method => "post" do
    end
  end
end
