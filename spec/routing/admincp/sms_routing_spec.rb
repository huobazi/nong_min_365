# -*- encoding : utf-8 -*-
require "spec_helper"

describe Admincp::SmsController do
  describe "routing" do

    it "routes to #index" do
      get("/admincp/sms").should route_to("admincp/sms#index")
    end

    it "routes to #new" do
      get("/admincp/sms/new").should route_to("admincp/sms#new")
    end

    it "routes to #show" do
      get("/admincp/sms/1").should route_to("admincp/sms#show", :id => "1")
    end

    it "routes to #edit" do
      get("/admincp/sms/1/edit").should route_to("admincp/sms#edit", :id => "1")
    end

    it "routes to #create" do
      post("/admincp/sms").should route_to("admincp/sms#create")
    end

    it "routes to #update" do
      put("/admincp/sms/1").should route_to("admincp/sms#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/admincp/sms/1").should route_to("admincp/sms#destroy", :id => "1")
    end

  end
end
