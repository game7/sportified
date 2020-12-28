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
require 'rails_helper'

RSpec.describe Tenant, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:slug) }
  end

  describe 'associations' do
    it { should have_and_belong_to_many(:users) }
  end

  describe 'before_validation' do
    it 'generates a slug if not provided' do
      tenant = Tenant.new host: 'booyah'
      tenant.valid?
      expect(tenant.host).to eq(tenant.slug)
    end

    it "should not generate a slug if provided" do
      slug = 'foobar'
      tenant = Tenant.new host: 'booyah', slug: slug
      tenant.valid?
      expect(slug).to eq(tenant.slug)
    end    
  end

  describe 'tenant' do
    before(:each) do
      @slug = 'foobar'
      @tenant = Tenant.new slug: @slug
    end
    it 'should provide a url based on host when present' do
      host = @tenant.host = 'foobar.com'
      expect(@tenant.url).to eq("http://#{host}")
    end
    it 'should provide a url based on the slug when host not present' do
      expect(@tenant.url).to eq("http://#{@slug}.sportified.net")
    end
    it 'should provide a secure url using the slug' do
      expect(@tenant.secure_url).to eq("https://#{@slug}.sportified.net")
    end  
  end
end
