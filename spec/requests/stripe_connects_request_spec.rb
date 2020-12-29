require 'rails_helper'

RSpec.describe StripeConnectsController do
  fixtures :tenants

  context 'without tenant' do
    it 'redirects to tenants_url' do
        post stripe_connects_path
        expect(response).to redirect_to(tenants_url)
    end     
  end

  context 'with tenant' do    
    it 'creates a StripeConnect' do   
      tenant_scope tenants(:hockey_league_site)
      referrer = '/registrar/registrations'
      post stripe_connects_path, headers: { "HTTP_REFERER": referrer }
      connect = StripeConnect.unscoped.last
      expect(connect).to be_instance_of(StripeConnect)
      expect(response).to redirect_to(connect.redirect)
    end

    it 'returns :back when cannot create a StripeConnect' do
      tenant_scope tenants(:football_league_site)
      referrer = 'http://localhost:3000/registrar/registrations'
      post stripe_connects_path, headers: { "HTTP_REFERER": referrer }
      expect(response).to redirect_to(referrer)
      expect(flash[:error]).to be_present  
    end
  end

end
