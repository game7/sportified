# == Schema Information
#
# Table name: locations
#
#  id         :integer          not null, primary key
#  deleted_at :datetime
#  name       :string
#  short_name :string
#  created_at :datetime
#  updated_at :datetime
#  tenant_id  :integer
#
# Indexes
#
#  index_locations_on_deleted_at  (deleted_at)
#  index_locations_on_tenant_id   (tenant_id)
#
class LocationSerializer < ActiveModel::Serializer
  attributes :id, :name, :short_name
end
