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
#  mongo_id              :string
#  created_at            :datetime
#  updated_at            :datetime
#  stripe_secret_api_key :string
#  stripe_public_api_key :string
#

class Tenant < ActiveRecord::Base
  include Tenancy::Resource

  has_and_belongs_to_many :users

  before_save :check_and_set_slug

  validates :name, :slug, presence: true

  validates :stripe_secret_api_key, length: { is: 32 }, allow_blank: true
  validates :stripe_public_api_key, length: { is: 32 }, allow_blank: true


  scope :for_host, ->(host) { where("host = ?", host) }

  class << self
    def current
      Thread.current[:current_tenant] = Thread.current[:current_tenant] || Tenant.first
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
