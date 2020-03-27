require 'test_helper'

class TenantTest < ActiveSupport::TestCase
  
  context :validations do
    should validate_presence_of(:name)
    should validate_presence_of(:slug)
    should validate_length_of(:stripe_public_api_key).is_equal_to(32)
  end

  context :associations do
    should have_and_belong_to_many(:users)
  end

  context :before_validate do
    should "generate a slug if not provided" do
      tenant = Tenant.new host: 'booyah'
      tenant.valid?
      assert_equal tenant.host, tenant.slug
    end
    should "should not generate a slug if provided" do
      slug = 'foobar'
      tenant = Tenant.new host: 'booyah', slug: slug
      tenant.valid?
      assert_equal slug, tenant.slug
    end    
  end

  context :tenant do
    setup do
      @slug = 'foobar'
      @tenant = Tenant.new slug: @slug
    end
    should "provide a url" do
      assert_equal "http://#{@slug}.sportified.net", @tenant.url
    end
    should "provide a secure url" do
      assert_equal "https://#{@slug}.sportified.net", @tenant.secure_url
    end
  end
  
end
