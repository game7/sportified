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
#  stripe_account_id     :string
#  stripe_public_api_key :string
#  stripe_access_token   :string
#

class TenantSerializer < ActiveModel::Serializer
  attributes :id, :name, :url
end
