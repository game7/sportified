require 'test_helper'

class Admin::Users::TeamsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get admin_users_teams_index_url
    assert_response :success
  end

end
