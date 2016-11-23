require 'test_helper'

module Rms
  class VariantsControllerTest < ActionController::TestCase
    setup do
      @routes = Engine.routes
    end

    test "should get register" do
      get :register
      assert_response :success
    end

  end
end
