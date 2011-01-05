require "spec_helper"

describe PlayersController do
  describe "routing" do

    it "recognizes and generates #index" do
      { :get => "/players" }.should route_to(:controller => "players", :action => "index")
    end

    it "recognizes and generates #new" do
      { :get => "/players/new" }.should route_to(:controller => "players", :action => "new")
    end

    it "recognizes and generates #show" do
      { :get => "/players/1" }.should route_to(:controller => "players", :action => "show", :id => "1")
    end

    it "recognizes and generates #edit" do
      { :get => "/players/1/edit" }.should route_to(:controller => "players", :action => "edit", :id => "1")
    end

    it "recognizes and generates #create" do
      { :post => "/players" }.should route_to(:controller => "players", :action => "create")
    end

    it "recognizes and generates #update" do
      { :put => "/players/1" }.should route_to(:controller => "players", :action => "update", :id => "1")
    end

    it "recognizes and generates #destroy" do
      { :delete => "/players/1" }.should route_to(:controller => "players", :action => "destroy", :id => "1")
    end

  end
end
