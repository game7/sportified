# == Schema Information
#
# Table name: facilities
#
#  id          :integer          not null, primary key
#  name        :string
#  type        :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  location_id :integer
#  tenant_id   :integer
#
# Indexes
#
#  index_facilities_on_location_id  (location_id)
#  index_facilities_on_tenant_id    (tenant_id)
#
# Foreign Keys
#
#  fk_rails_...  (location_id => locations.id)
#
class Facility < ActiveRecord::Base
  include Sportified::TenantScoped

  belongs_to :location

  validates :location, presence: true
  validates :name, presence: true
end
