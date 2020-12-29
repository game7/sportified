require 'rails_helper'

RSpec.describe "Registrations", type: :request do
  fixtures :tenants, :users

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

end
