require 'test_helper'

module Rms
  class AdminControllerTest < ActionDispatch::IntegrationTest
    include Engine.routes.url_helpers

    test "should get index" do
      get admin_index_url
      assert_response :success
    end

  end
end
