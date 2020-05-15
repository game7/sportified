require 'test_helper'

class Admin::Registrar::DashboardControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get admin_registrar_dashboard_index_url
    assert_response :success
  end

end
