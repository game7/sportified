# == Schema Information
#
# Table name: registrar_registration_types
#
#  id                 :integer          not null, primary key
#  tenant_id          :integer
#  registrable_id     :integer
#  title              :string(30)
#  description        :text
#  price              :decimal(20, 4)
#  quantity_allowed   :integer
#  quantity_available :integer
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#

require 'rails_helper'

# This spec was generated by rspec-rails when you ran the scaffold generator.
# It demonstrates how one might use RSpec to specify the controller code that
# was generated by Rails when you ran the scaffold generator.
#
# It assumes that the implementation code is generated by the rails scaffold
# generator.  If you are using any extension libraries to generate different
# controller code, this generated spec may or may not pass.
#
# It only uses APIs available in rails and/or rspec-rails.  There are a number
# of tools you can use to make these specs even more expressive, but we're
# sticking to rails and rspec-rails APIs to keep things simple and stable.
#
# Compared to earlier versions of this generator, there is very limited use of
# stubs and message expectations in this spec.  Stubs are only used when there
# is no simpler way to get a handle on the object needed for the example.
# Message expectations are only used when there is no simpler way to specify
# that an instance is receiving a specific message.

RSpec.describe Registrar::RegistrationTypesController, :type => :controller do

  # This should return the minimal set of attributes required to create a valid
  # Registrar::RegistrationType. As you add validations to Registrar::RegistrationType, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) {
    skip("Add a hash of attributes valid for your model")
  }

  let(:invalid_attributes) {
    skip("Add a hash of attributes invalid for your model")
  }

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # Registrar::RegistrationTypesController. Be sure to keep this updated too.
  let(:valid_session) { {} }

  describe "GET index" do
    it "assigns all registrar_registration_types as @registrar_registration_types" do
      registration_type = Registrar::RegistrationType.create! valid_attributes
      get :index, {}, valid_session
      expect(assigns(:registrar_registration_types)).to eq([registration_type])
    end
  end

  describe "GET show" do
    it "assigns the requested registrar_registration_type as @registrar_registration_type" do
      registration_type = Registrar::RegistrationType.create! valid_attributes
      get :show, {:id => registration_type.to_param}, valid_session
      expect(assigns(:registrar_registration_type)).to eq(registration_type)
    end
  end

  describe "GET new" do
    it "assigns a new registrar_registration_type as @registrar_registration_type" do
      get :new, {}, valid_session
      expect(assigns(:registrar_registration_type)).to be_a_new(Registrar::RegistrationType)
    end
  end

  describe "GET edit" do
    it "assigns the requested registrar_registration_type as @registrar_registration_type" do
      registration_type = Registrar::RegistrationType.create! valid_attributes
      get :edit, {:id => registration_type.to_param}, valid_session
      expect(assigns(:registrar_registration_type)).to eq(registration_type)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new Registrar::RegistrationType" do
        expect {
          post :create, {:registrar_registration_type => valid_attributes}, valid_session
        }.to change(Registrar::RegistrationType, :count).by(1)
      end

      it "assigns a newly created registrar_registration_type as @registrar_registration_type" do
        post :create, {:registrar_registration_type => valid_attributes}, valid_session
        expect(assigns(:registrar_registration_type)).to be_a(Registrar::RegistrationType)
        expect(assigns(:registrar_registration_type)).to be_persisted
      end

      it "redirects to the created registrar_registration_type" do
        post :create, {:registrar_registration_type => valid_attributes}, valid_session
        expect(response).to redirect_to(Registrar::RegistrationType.last)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved registrar_registration_type as @registrar_registration_type" do
        post :create, {:registrar_registration_type => invalid_attributes}, valid_session
        expect(assigns(:registrar_registration_type)).to be_a_new(Registrar::RegistrationType)
      end

      it "re-renders the 'new' template" do
        post :create, {:registrar_registration_type => invalid_attributes}, valid_session
        expect(response).to render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      let(:new_attributes) {
        skip("Add a hash of attributes valid for your model")
      }

      it "updates the requested registrar_registration_type" do
        registration_type = Registrar::RegistrationType.create! valid_attributes
        put :update, {:id => registration_type.to_param, :registrar_registration_type => new_attributes}, valid_session
        registration_type.reload
        skip("Add assertions for updated state")
      end

      it "assigns the requested registrar_registration_type as @registrar_registration_type" do
        registration_type = Registrar::RegistrationType.create! valid_attributes
        put :update, {:id => registration_type.to_param, :registrar_registration_type => valid_attributes}, valid_session
        expect(assigns(:registrar_registration_type)).to eq(registration_type)
      end

      it "redirects to the registrar_registration_type" do
        registration_type = Registrar::RegistrationType.create! valid_attributes
        put :update, {:id => registration_type.to_param, :registrar_registration_type => valid_attributes}, valid_session
        expect(response).to redirect_to(registration_type)
      end
    end

    describe "with invalid params" do
      it "assigns the registrar_registration_type as @registrar_registration_type" do
        registration_type = Registrar::RegistrationType.create! valid_attributes
        put :update, {:id => registration_type.to_param, :registrar_registration_type => invalid_attributes}, valid_session
        expect(assigns(:registrar_registration_type)).to eq(registration_type)
      end

      it "re-renders the 'edit' template" do
        registration_type = Registrar::RegistrationType.create! valid_attributes
        put :update, {:id => registration_type.to_param, :registrar_registration_type => invalid_attributes}, valid_session
        expect(response).to render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested registrar_registration_type" do
      registration_type = Registrar::RegistrationType.create! valid_attributes
      expect {
        delete :destroy, {:id => registration_type.to_param}, valid_session
      }.to change(Registrar::RegistrationType, :count).by(-1)
    end

    it "redirects to the registrar_registration_types list" do
      registration_type = Registrar::RegistrationType.create! valid_attributes
      delete :destroy, {:id => registration_type.to_param}, valid_session
      expect(response).to redirect_to(registrar_registration_types_url)
    end
  end

end
