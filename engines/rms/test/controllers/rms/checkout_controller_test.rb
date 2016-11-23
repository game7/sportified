require 'test_helper'

module Rms
  class CheckoutControllerTest < ActionController::TestCase
    setup do
      @routes = Engine.routes
    end

    test "should get form" do
      get :form
      assert_response :success
    end

    test "should get payment" do
      get :payment
      assert_response :success
    end

    test "should get confirmation" do
      get :confirmation
      assert_response :success
    end

  end
end
