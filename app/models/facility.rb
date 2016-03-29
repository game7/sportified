# == Schema Information
#
# Table name: facilities
#
#  id          :integer          not null, primary key
#  type        :string
#  name        :string
#  tenant_id   :integer
#  location_id :integer
#  parent_id   :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  preference  :string
#

class Facility < ActiveRecord::Base
  include Sportified::TenantScoped

  belongs_to :location

  validates :location, presence: true
  validates :name, presence: true
end
