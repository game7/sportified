require 'test_helper'
require 'minitest/mock'

class StripeConnectFlowTest < ActionDispatch::IntegrationTest

  setup do
    Tenant.current = tenants(:hockey_league_site)
    Tenant.current.stripe_client_id = 'bogus-stripe-client-id'  
  end

  context 'when user has denied access' do

    setup do
      @referrer = 'http://localhost:3000/registrar/registrations'
      post '/stripe_connects', headers: { "HTTP_REFERER": @referrer }
      @connect = StripeConnect.last

      @error_description = "The user denied your request"
      get "/?state=#{@connect.token}&error=access_denied&error_description=#{@error_description}"
    end

    should 'update stripe connect status' do 
      @connect.reload
      assert_equal 'access_denied', @connect.status
    end

    should 'redirect to referrer' do     
      assert_redirected_to @referrer
    end

    should 'flash a error description' do
      assert_equal @error_description, flash[:error]
    end

  end

  context 'when stripe connect is completed' do

    setup do
      @referrer = 'http://localhost:3000/registrar/registrations'
      post '/stripe_connects', headers: { "HTTP_REFERER": @referrer }
      @connect = StripeConnect.last

      @scope = 'read_write'
      @code = 'ac_123456789'
      @payload = OpenStruct.new({
        stripe_user_id: SecureRandom.base58(32),
        access_token: SecureRandom.base58(32),
        stripe_publishable_key: SecureRandom.base58(32)
      })
      Stripe::OAuth.stub :token, @payload do
        get "/?state=#{@connect.token}&scope=#{@scope}&code=#{@code}"
      end
    end

    context 'when updating tenant it' do
      setup do
        @tenant = @connect.tenant.reload
      end

      should 'set stripe_account_id' do
        assert_equal @payload.stripe_user_id, @tenant.stripe_account_id
      end

      should 'set stripe_access_token' do
        assert_equal @payload.access_token, @tenant.stripe_access_token
      end

      should 'set stripe_public_api_key' do
        assert_equal @payload.stripe_publishable_key, @tenant.stripe_public_api_key
      end
    end 

    should 'update stripe connect status' do 
      @connect.reload
      assert_equal 'completed', @connect.status
    end

    should 'redirect to referrer' do
      assert_redirected_to @connect.referrer
    end

    should 'flash a success message' do
      assert_equal 'Stripe has been connected!', flash[:success]
    end

  end

end
