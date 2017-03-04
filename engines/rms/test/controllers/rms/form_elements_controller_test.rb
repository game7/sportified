require 'test_helper'

module Rms
  class FormElementsControllerTest < ActionDispatch::IntegrationTest
    include Engine.routes.url_helpers

    test "should get NEW" do
      get form_elements_NEW_url
      assert_response :success
    end

    test "should get EDIT" do
      get form_elements_EDIT_url
      assert_response :success
    end

  end
end
