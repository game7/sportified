require "rails_helper"

RSpec.describe Registrar::RegistrablesController, :type => :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/registrar/registrables").to route_to("registrar/registrables#index")
    end

    it "routes to #new" do
      expect(:get => "/registrar/registrables/new").to route_to("registrar/registrables#new")
    end

    it "routes to #show" do
      expect(:get => "/registrar/registrables/1").to route_to("registrar/registrables#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/registrar/registrables/1/edit").to route_to("registrar/registrables#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/registrar/registrables").to route_to("registrar/registrables#create")
    end

    it "routes to #update" do
      expect(:put => "/registrar/registrables/1").to route_to("registrar/registrables#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/registrar/registrables/1").to route_to("registrar/registrables#destroy", :id => "1")
    end

  end
end
