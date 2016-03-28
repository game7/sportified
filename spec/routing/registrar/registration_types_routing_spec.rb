# == Schema Information
#
# Table name: registrar_registration_types
#
#  id                   :integer          not null, primary key
#  tenant_id            :integer
#  registrar_session_id :integer
#  title                :string(30)
#  description          :text
#  price                :decimal(20, 4)
#  quantity_allowed     :integer
#  quantity_available   :integer
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#

require "rails_helper"

RSpec.describe Registrar::RegistrationTypesController, :type => :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/registrar/registration_types").to route_to("registrar/registration_types#index")
    end

    it "routes to #new" do
      expect(:get => "/registrar/registration_types/new").to route_to("registrar/registration_types#new")
    end

    it "routes to #show" do
      expect(:get => "/registrar/registration_types/1").to route_to("registrar/registration_types#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/registrar/registration_types/1/edit").to route_to("registrar/registration_types#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/registrar/registration_types").to route_to("registrar/registration_types#create")
    end

    it "routes to #update" do
      expect(:put => "/registrar/registration_types/1").to route_to("registrar/registration_types#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/registrar/registration_types/1").to route_to("registrar/registration_types#destroy", :id => "1")
    end

  end
end
