require 'rails_helper'

RSpec.describe StripeConnectsController do
  fixtures :tenants

  context 'without tenant' do
    before(:each) do
        Tenant.current = nil            
    end

    it 'redirects to tenants_url' do
        post stripe_connects_path
        expect(response).to redirect_to(tenants_url)
    end     
  end

  context 'with tenant' do
    before(:each) do
        Tenant.current = tenants(:hockey_league_site)           
    end     
    
    it 'creates a StripeConnect' do
      Tenant.current.stripe_client_id = 'bogus-stripe-client-id'      
      referrer = '/registrar/registrations'
      post stripe_connects_path, headers: { "HTTP_REFERER": referrer }
      # TODO: need to get tenant into session so that it spans redirect
      Tenant.current = tenants(:hockey_league_site)
      connect = StripeConnect.last
      expect(connect).to be_instance_of(StripeConnect)
      expect(response).to redirect_to(connect.redirect)
    end

    it 'returns :back when cannot create a StripeConnect' do
      referrer = 'http://localhost:3000/registrar/registrations'
      post stripe_connects_path, headers: { "HTTP_REFERER": referrer }
      expect(response).to redirect_to(referrer)
      expect(flash[:error]).to be_present  
    end
  end

end
