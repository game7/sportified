require 'test_helper'

module Rms
  class FormsControllerTest < ActionController::TestCase
    setup do
      @form = rms_forms(:one)
      @routes = Engine.routes
    end

    test "should get index" do
      get :index
      assert_response :success
      assert_not_nil assigns(:forms)
    end

    test "should get new" do
      get :new
      assert_response :success
    end

    test "should create form" do
      assert_difference('Form.count') do
        post :create, form: { name: @form.name, tenant_id: @form.tenant_id }
      end

      assert_redirected_to form_path(assigns(:form))
    end

    test "should show form" do
      get :show, id: @form
      assert_response :success
    end

    test "should get edit" do
      get :edit, id: @form
      assert_response :success
    end

    test "should update form" do
      patch :update, id: @form, form: { name: @form.name, tenant_id: @form.tenant_id }
      assert_redirected_to form_path(assigns(:form))
    end

    test "should destroy form" do
      assert_difference('Form.count', -1) do
        delete :destroy, id: @form
      end

      assert_redirected_to forms_path
    end
  end
end
