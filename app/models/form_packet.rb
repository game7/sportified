# == Schema Information
#
# Table name: form_packets
#
#  id         :integer          not null, primary key
#  tenant_id  :integer
#  name       :string(40)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_form_packets_on_tenant_id  (tenant_id)
#
# Foreign Keys
#
#  fk_rails_...  (tenant_id => tenants.id)
#

class FormPacket < ApplicationRecord
  include Sportified::TenantScoped

  has_many :variants

  has_many :templates, -> {order(:position)},
                       class_name: 'FormTemplate',
                       foreign_key: 'packet_id'

  validates :name, presence: true

end
