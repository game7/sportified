# == Schema Information
#
# Table name: tenants
#
#  id                    :integer          not null, primary key
#  name                  :string
#  slug                  :string
#  host                  :string
#  description           :text
#  analytics_id          :string
#  theme                 :string
#  twitter_id            :string
#  facebook_id           :string
#  instagram_id          :string
#  foursquare_id         :string
#  google_plus_id        :string
#  created_at            :datetime
#  updated_at            :datetime
#  stripe_account_id     :string
#  stripe_public_api_key :string
#  stripe_access_token   :string
#  google_fonts          :string
#  time_zone             :string           default("UTC")
#  address               :text
#  stripe_client_id      :string
#  stripe_private_key    :string
#  stripe_public_key     :string
#  style                 :text
#

class Tenant < ActiveRecord::Base
  include Tenancy::Resource

  has_and_belongs_to_many :users

  before_save :check_and_set_slug

  validates :name, :slug, presence: true

  validates :stripe_public_api_key, length: { is: 32 }, allow_blank: true

  scope :for_host, ->(host) { where("host = ?", host) }

  def url
    "http://#{host ? host : slug+'.sportified.net'}"
  end

  def secure_url
    "https://#{slug}.sportified.net"
  end

  class << self
    def current
      Thread.current[:current_tenant] = Thread.current[:current_tenant]
    end
    def current=(tenant)
      Thread.current[:current_tenant] = tenant
    end
  end

  def check_and_set_slug
    self.slug ||= self.host.parameterize
  end

  def apply_mongo_user_ids!(user)

  end

  def apply_mongo! mongo
    self.twitter_id = mongo["twitter_id"]
    self.facebook_id = mongo["facebook_id"]
    self.instagram_id = mongo["instagram_id"]
    self.foursquare_id = mongo["foursquare_id"]
    self.google_plus_id = mongo["google_plus_id"]
  end

end
