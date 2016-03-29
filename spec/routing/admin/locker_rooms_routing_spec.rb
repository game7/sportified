require "rails_helper"

RSpec.describe Admin::LockerRoomsController, :type => :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/admin/locker_rooms").to route_to("admin/locker_rooms#index")
    end

    it "routes to #new" do
      expect(:get => "/admin/locker_rooms/new").to route_to("admin/locker_rooms#new")
    end

    it "routes to #show" do
      expect(:get => "/admin/locker_rooms/1").to route_to("admin/locker_rooms#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/admin/locker_rooms/1/edit").to route_to("admin/locker_rooms#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/admin/locker_rooms").to route_to("admin/locker_rooms#create")
    end

    it "routes to #update" do
      expect(:put => "/admin/locker_rooms/1").to route_to("admin/locker_rooms#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/admin/locker_rooms/1").to route_to("admin/locker_rooms#destroy", :id => "1")
    end

  end
end
