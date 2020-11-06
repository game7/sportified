# == Schema Information
#
# Table name: clubs
#
#  id         :integer          not null, primary key
#  name       :string
#  short_name :string
#  created_at :datetime
#  updated_at :datetime
#  tenant_id  :integer
#
# Indexes
#
#  index_clubs_on_tenant_id  (tenant_id)
#
class ClubSerializer < ActiveModel::Serializer
  attributes :id,
    :name,  
    :short_name,
    :tenant_id,
    :created_at,
    :updated_at
end
