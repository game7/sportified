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

require 'rails_helper'

RSpec.describe Tenant, :type => :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
