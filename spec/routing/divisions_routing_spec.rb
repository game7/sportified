require "spec_helper"

describe DivisionsController do
  describe "routing" do

    it "recognizes and generates #index" do
      { :get => "/divisions" }.should route_to(:controller => "divisions", :action => "index")
    end

    it "recognizes and generates #new" do
      { :get => "/divisions/new" }.should route_to(:controller => "divisions", :action => "new")
    end

    it "recognizes and generates #show" do
      { :get => "/divisions/1" }.should route_to(:controller => "divisions", :action => "show", :id => "1")
    end

    it "recognizes and generates #edit" do
      { :get => "/divisions/1/edit" }.should route_to(:controller => "divisions", :action => "edit", :id => "1")
    end

    it "recognizes and generates #create" do
      { :post => "/divisions" }.should route_to(:controller => "divisions", :action => "create")
    end

    it "recognizes and generates #update" do
      { :put => "/divisions/1" }.should route_to(:controller => "divisions", :action => "update", :id => "1")
    end

    it "recognizes and generates #destroy" do
      { :delete => "/divisions/1" }.should route_to(:controller => "divisions", :action => "destroy", :id => "1")
    end

  end
end
