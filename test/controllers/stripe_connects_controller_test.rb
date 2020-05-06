require 'test_helper'

class StripeConnectsControllerTest < ActionDispatch::IntegrationTest

  context :without_tenant do
    should "redirect to tenants" do
      Tenant.current = nil
      post '/stripe_connects'
      assert_redirected_to tenants_path
    end
  end

  context :with_tenant do

    setup do
      Tenant.current = tenants(:hockey_league_site)
    end

    should "create a stripe_connect" do
      Tenant.current.stripe_client_id = 'bogus-stripe-client-id'      
      referrer = 'http://localhost:3000/registrar/registrations'
      post '/stripe_connects', headers: { "HTTP_REFERER": referrer }
      connect = StripeConnect.last
      assert_instance_of StripeConnect, connect
      assert_redirected_to connect.redirect
    end

    should "return back when cannot create stripe_account" do   
      referrer = 'http://localhost:3000/registrar/registrations'
      post '/stripe_connects', headers: { "HTTP_REFERER": referrer }
      assert_redirected_to referrer
      assert_equal 'There seems to have been a problem', flash[:error]
    end    

  end  

end
