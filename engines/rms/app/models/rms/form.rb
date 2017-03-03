# == Schema Information
#
# Table name: rms_forms
#
#  id              :integer          not null, primary key
#  tenant_id       :integer
#  registration_id :integer
#  template_id     :integer
#  data            :hstore
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  completed       :boolean          default(FALSE), not null
#
# Indexes
#
#  index_rms_forms_on_tenant_id  (tenant_id)
#
# Foreign Keys
#
#  fk_rails_2d7d45163d  (registration_id => rms_registrations.id)
#  fk_rails_7767919c08  (template_id => rms_form_templates.id)
#  fk_rails_e5d5d313a2  (tenant_id => tenants.id)
#

module Rms
  class Form < ActiveRecord::Base
    include Sportified::TenantScoped

    belongs_to :registration
    belongs_to :template, class_name: 'Rms::FormTemplate'

    has_many :elements, -> {order(:position)},
                      through: :template,
                      class_name: 'Rms::FormElement'

    store_accessor :data

    validates :registration, presence: true
    validates :template, presence: true

    validate :validate_elements
    def validate_elements
      template.elements.each do |element|
        element.validate(self)
      end unless new_record?
    end

    scope :incomplete, -> { where.not(completed: true) }

    after_initialize :add_element_accessors
    def add_element_accessors
      self.template.elements.each do |element|
        element.accessors.each do |accessor|
          singleton_class.class_eval { store_accessor :data, accessor }
        end
      end unless new_record?
    end

  end
end
