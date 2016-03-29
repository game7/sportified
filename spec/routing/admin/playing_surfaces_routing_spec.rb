require "rails_helper"

RSpec.describe Admin::PlayingSurfacesController, :type => :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/admin/playing_surfaces").to route_to("admin/playing_surfaces#index")
    end

    it "routes to #new" do
      expect(:get => "/admin/playing_surfaces/new").to route_to("admin/playing_surfaces#new")
    end

    it "routes to #show" do
      expect(:get => "/admin/playing_surfaces/1").to route_to("admin/playing_surfaces#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/admin/playing_surfaces/1/edit").to route_to("admin/playing_surfaces#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/admin/playing_surfaces").to route_to("admin/playing_surfaces#create")
    end

    it "routes to #update" do
      expect(:put => "/admin/playing_surfaces/1").to route_to("admin/playing_surfaces#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/admin/playing_surfaces/1").to route_to("admin/playing_surfaces#destroy", :id => "1")
    end

  end
end
