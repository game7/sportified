require 'rails_helper'

RSpec.describe "Registrations", type: :request do
  fixtures :tenants, :users, :products, :variants

  before(:each) do
    tenant_scope tenants(:hockey_league_site)     
  end

  context 'for anonymous user' do
    it 'should NOT list registrations' do
      get '/registrations'
      expect(response).to redirect_to(Passwordless::Engine.routes.url_helpers.sign_in_path)
    end

  end

  context 'for signed in user' do
    before(:each) do
      login_as users(:wayne) 
    end

    it 'should list registrations' do
      get '/registrations'
      expect(response).to render_template(:index)
    end
  end

  describe 'new registrations' do
    
    it 'should render form' do
      variant = variants(:variant_with_price)
      get new_variant_registration_path(variant)
      expect(response).to render_template(:new)
    end

  end

  describe 'create' do

    describe 'for free products' do
      it 'should redirect to show registration page' do
        variant = variants(:variant_without_price)
        post variant_registrations_path(variant), params: {
          registration: {
            first_name: 'Homer',
            last_name: 'Simposon',
            birthdate: '1980/1/1',
            email: 'homer@doh.com'
          }
        }
        registration = Registration.unscoped.last
        expect(response).to redirect_to(registration_path(registration.uuid))
      end 
    end

    describe 'for paid products' do
      it 'should redirect to collect page' do
        variant = variants(:variant_with_price)
        post variant_registrations_path(variant), params: {
          registration: {
            first_name: 'Homer',
            last_name: 'Simposon',
            birthdate: '1980/1/1',
            email: 'homer@doh.com'
          }
        }
        registration = Registration.unscoped.last
        expect(response).to redirect_to(collect_registration_path(registration.uuid))
      end 
    end    
  
  end

  describe 'collect' do

    describe 'for free or already-paid products' do
      it 'should redirect to show registration page' do
        variant = variants(:variant_without_price)
        post variant_registrations_path(variant), params: {
          registration: {
            first_name: 'Homer',
            last_name: 'Simposon',
            birthdate: '1980/1/1',
            email: 'homer@doh.com'
          }
        }
        registration = Registration.unscoped.last
        get collect_registration_path(registration.uuid)
        expect(response).to redirect_to(registration_path(registation.uuid))
      end 
    end

  end

end
