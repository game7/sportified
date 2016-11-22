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

module Rms
  class FormTemplate < ActiveRecord::Base
    include Sportified::TenantScoped

    belongs_to :packet, class_name: 'Rms::FormPacket'
    has_many :fields, -> {order(:position)},
                      class_name: 'Rms::FormField', 
                      foreign_key: 'template_id'

    validates :name, presence: true
    validates :position, presence: true,
                         numericality: { only_integer: true }

    def field_names
      fields.collect { |f| f.name }
    end

    def permitted_params
      field_names
    end

  end
end
