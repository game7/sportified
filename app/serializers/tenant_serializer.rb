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
class TenantSerializer < ActiveModel::Serializer
  attributes :id, :name, :url
end
