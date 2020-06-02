require 'test_helper'

class Admin::Products::AttendanceControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get admin_products_attendance_index_url
    assert_response :success
  end

end
