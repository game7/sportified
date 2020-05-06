require 'test_helper'

class Rms::RegistrationsControllerTest < ActionDispatch::IntegrationTest
  
  context :with_tenant do

    setup do
      Tenant.current = tenants(:hockey_league_site)
    end

    should "get the collect route" do
      get collect_registration_path 'abc'
      assert_response :success
    end

  end

end
