# == Schema Information
#
# Table name: tenants
#
#  id             :integer          not null, primary key
#  name           :string(255)
#  slug           :string(255)
#  host           :string(255)
#  description    :text
#  analytics_id   :string(255)
#  theme          :string(255)
#  twitter_id     :string(255)
#  facebook_id    :string(255)
#  instagram_id   :string(255)
#  foursquare_id  :string(255)
#  google_plus_id :string(255)
#  mongo_id       :string(255)
#  created_at     :datetime
#  updated_at     :datetime
#

class Tenant < ActiveRecord::Base
  include Tenancy::Resource

  has_and_belongs_to_many :users

  before_save :check_and_set_slug

  validates :name, :slug, presence: true

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
