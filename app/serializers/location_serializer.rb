# == Schema Information
#
# Table name: locations
#
#  id         :integer          not null, primary key
#  tenant_id  :integer
#  name       :string
#  short_name :string
#  mongo_id   :string
#  created_at :datetime
#  updated_at :datetime
#

class LocationSerializer < ActiveModel::Serializer
  attributes :id, :name, :short_name
end
