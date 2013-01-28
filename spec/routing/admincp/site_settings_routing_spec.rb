# -*- encoding : utf-8 -*-
require "spec_helper"

describe Admincp::SiteSettingsController do
  describe "routing" do

    it "routes to #index" do
      get("/admincp/site_settings").should route_to("admincp/site_settings#index")
    end

    it "routes to #new" do
      get("/admincp/site_settings/new").should route_to("admincp/site_settings#new")
    end

    it "routes to #show" do
      get("/admincp/site_settings/1").should route_to("admincp/site_settings#show", :id => "1")
    end

    it "routes to #edit" do
      get("/admincp/site_settings/1/edit").should route_to("admincp/site_settings#edit", :id => "1")
    end

    it "routes to #create" do
      post("/admincp/site_settings").should route_to("admincp/site_settings#create")
    end

    it "routes to #update" do
      put("/admincp/site_settings/1").should route_to("admincp/site_settings#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/admincp/site_settings/1").should route_to("admincp/site_settings#destroy", :id => "1")
    end

  end
end
