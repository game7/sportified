require 'test_helper'

class Admin::Users::RegistrationsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get admin_users_registrations_index_url
    assert_response :success
  end

end
