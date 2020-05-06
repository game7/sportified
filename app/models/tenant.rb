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
  has_many_attached :assets

  before_validation :check_and_set_slug

  validates :name, presence: true
  validates :slug, presence: true

  scope :for_host, ->(host) { where('host = ?', host) }

  def slug_host
    "#{slug}.sportified.net"
  end

  def url
    "http://#{host || slug_host}"
  end

  def secure_url
    "https://" + slug_host
  end

  class << self
    def current
      Thread.current[:current_tenant]
    end
    def current=(tenant)
      Thread.current[:current_tenant] = tenant
    end
  end

  def check_and_set_slug
    self.slug ||= self.host&.parameterize
  end

end
