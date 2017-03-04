require 'test_helper'

module Rms
  class FormPacketsControllerTest < ActionDispatch::IntegrationTest
    include Engine.routes.url_helpers

    setup do
      @form_packet = rms_form_packets(:one)
    end

    test "should get index" do
      get form_packets_url
      assert_response :success
    end

    test "should get new" do
      get new_form_packet_url
      assert_response :success
    end

    test "should create form_packet" do
      assert_difference('FormPacket.count') do
        post form_packets_url, params: { form_packet: { name: @form_packet.name } }
      end

      assert_redirected_to form_packet_url(FormPacket.last)
    end

    test "should show form_packet" do
      get form_packet_url(@form_packet)
      assert_response :success
    end

    test "should get edit" do
      get edit_form_packet_url(@form_packet)
      assert_response :success
    end

    test "should update form_packet" do
      patch form_packet_url(@form_packet), params: { form_packet: { name: @form_packet.name } }
      assert_redirected_to form_packet_url(@form_packet)
    end

    test "should destroy form_packet" do
      assert_difference('FormPacket.count', -1) do
        delete form_packet_url(@form_packet)
      end

      assert_redirected_to form_packets_url
    end
  end
end
