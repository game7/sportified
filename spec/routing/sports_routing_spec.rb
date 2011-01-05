require "spec_helper"

describe SportsController do
  describe "routing" do

    it "recognizes and generates #index" do
      { :get => "/sports" }.should route_to(:controller => "sports", :action => "index")
    end

    it "recognizes and generates #new" do
      { :get => "/sports/new" }.should route_to(:controller => "sports", :action => "new")
    end

    it "recognizes and generates #show" do
      { :get => "/sports/1" }.should route_to(:controller => "sports", :action => "show", :id => "1")
    end

    it "recognizes and generates #edit" do
      { :get => "/sports/1/edit" }.should route_to(:controller => "sports", :action => "edit", :id => "1")
    end

    it "recognizes and generates #create" do
      { :post => "/sports" }.should route_to(:controller => "sports", :action => "create")
    end

    it "recognizes and generates #update" do
      { :put => "/sports/1" }.should route_to(:controller => "sports", :action => "update", :id => "1")
    end

    it "recognizes and generates #destroy" do
      { :delete => "/sports/1" }.should route_to(:controller => "sports", :action => "destroy", :id => "1")
    end

  end
end
