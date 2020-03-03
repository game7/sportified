# == Schema Information
#
# Table name: clubs
#
#  id         :integer          not null, primary key
#  name       :string
#  short_name :string
#  tenant_id  :integer
#  created_at :datetime
#  updated_at :datetime
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
