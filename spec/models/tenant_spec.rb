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

require 'rails_helper'

RSpec.describe Tenant, :type => :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
