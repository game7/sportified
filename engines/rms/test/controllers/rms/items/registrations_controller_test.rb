require 'test_helper'

module Rms
  class Items::RegistrationsControllerTest < ActionDispatch::IntegrationTest
    include Engine.routes.url_helpers

    test "should get index" do
      get items_registrations_index_url
      assert_response :success
    end

  end
end
