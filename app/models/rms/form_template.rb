# == Schema Information
#
# Table name: rms_form_templates
#
#  id         :integer          not null, primary key
#  tenant_id  :integer
#  packet_id  :integer
#  name       :string(40)
#  position   :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_rms_form_templates_on_tenant_id  (tenant_id)
#
# Foreign Keys
#
#  fk_rails_...  (packet_id => rms_form_packets.id)
#  fk_rails_...  (tenant_id => tenants.id)
#

module Rms
  class FormTemplate < ActiveRecord::Base
    include Sportified::TenantScoped

    belongs_to :packet, class_name: 'Rms::FormPacket'
    has_many :elements, -> { order(:position) },
                      class_name: 'Rms::FormElement',
                      foreign_key: 'template_id'
    has_many :forms, foreign_key: 'template_id'

    validates :name, presence: true
    validates :position, presence: true,
                         numericality: { only_integer: true }

    def element_names
      elements.collect { |e| e.name }
    end

    def permitted_params
      elements.collect{|e| e.permitted_params }.flatten
    end

  end
end
