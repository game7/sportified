require 'test_helper'

class PagesControllerTest < ActionDispatch::IntegrationTest

  context :without_tenant do
    should "redirect to tenants" do
      Tenant.current = nil
      get root_path
      assert_redirected_to tenants_path
    end
  end

  context :with_tenant do

    setup do
      Tenant.current = tenants(:hockey_league_site)
    end

    should "get the home page" do
      get root_path
      assert_response :success
    end

    should "get the contact us page" do
      get '/pages/about/contact-us'
      assert_response :success
    end

    should "not the home page for paths that do not exist" do
      get '/pages/does-not-exist'
      assert_response :success
      assert_select 'title', "Welcome :: #{Tenant.current.name}"
    end

  end

end
