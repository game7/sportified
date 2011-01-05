require "spec_helper"

describe SeasonsController do
  describe "routing" do

    it "recognizes and generates #index" do
      { :get => "/seasons" }.should route_to(:controller => "seasons", :action => "index")
    end

    it "recognizes and generates #new" do
      { :get => "/seasons/new" }.should route_to(:controller => "seasons", :action => "new")
    end

    it "recognizes and generates #show" do
      { :get => "/seasons/1" }.should route_to(:controller => "seasons", :action => "show", :id => "1")
    end

    it "recognizes and generates #edit" do
      { :get => "/seasons/1/edit" }.should route_to(:controller => "seasons", :action => "edit", :id => "1")
    end

    it "recognizes and generates #create" do
      { :post => "/seasons" }.should route_to(:controller => "seasons", :action => "create")
    end

    it "recognizes and generates #update" do
      { :put => "/seasons/1" }.should route_to(:controller => "seasons", :action => "update", :id => "1")
    end

    it "recognizes and generates #destroy" do
      { :delete => "/seasons/1" }.should route_to(:controller => "seasons", :action => "destroy", :id => "1")
    end

  end
end
