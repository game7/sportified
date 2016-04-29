# == Schema Information
#
# Table name: registrar_sessions
#
#  id                      :integer          not null, primary key
#  registrable_id          :integer
#  registrable_type        :string
#  title                   :string(30)
#  description             :text
#  registrations_allowed   :integer
#  registrations_available :integer
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#

require "rails_helper"

RSpec.describe Registrar::SessionsController, :type => :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/registrar/sessions").to route_to("registrar/sessions#index")
    end

    it "routes to #new" do
      expect(:get => "/registrar/sessions/new").to route_to("registrar/sessions#new")
    end

    it "routes to #show" do
      expect(:get => "/registrar/sessions/1").to route_to("registrar/sessions#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/registrar/sessions/1/edit").to route_to("registrar/sessions#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/registrar/sessions").to route_to("registrar/sessions#create")
    end

    it "routes to #update" do
      expect(:put => "/registrar/sessions/1").to route_to("registrar/sessions#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/registrar/sessions/1").to route_to("registrar/sessions#destroy", :id => "1")
    end

  end
end
