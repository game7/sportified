# == Schema Information
#
# Table name: tenants
#
#  id                    :integer          not null, primary key
#  address               :text
#  description           :text
#  google_fonts          :string
#  host                  :string
#  name                  :string
#  slug                  :string
#  stripe_access_token   :string
#  stripe_private_key    :string
#  stripe_public_api_key :string
#  stripe_public_key     :string
#  style                 :text
#  theme                 :string
#  time_zone             :string           default("UTC")
#  created_at            :datetime
#  updated_at            :datetime
#  analytics_id          :string
#  facebook_id           :string
#  foursquare_id         :string
#  google_plus_id        :string
#  instagram_id          :string
#  stripe_account_id     :string
#  stripe_client_id      :string
#  twitter_id            :string
#
require 'test_helper'

class TenantTest < ActiveSupport::TestCase

  context :validations do
    should validate_presence_of(:name)
    should validate_presence_of(:slug)
  end

  context :associations do
    should have_and_belong_to_many(:users)
  end

  context :before_validation do
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
    should "provide a url based on host when present" do
      host = @tenant.host = 'foobar.com'
      assert_equal "http://#{host}", @tenant.url
    end
    should "provide a url based on the slug when host not present" do
      assert_equal "http://#{@slug}.sportified.net", @tenant.url
    end
    should "provide a secure url using the slug" do
      assert_equal "https://#{@slug}.sportified.net", @tenant.secure_url
    end
  end

end
