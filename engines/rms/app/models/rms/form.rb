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
#

module Rms
  class Form < ActiveRecord::Base
    include Sportified::TenantScoped

    belongs_to :registration
    belongs_to :template, class_name: 'Rms::FormTemplate'

    has_many :fields, -> {order(:position)},
                      through: :template,
                      class_name: 'Rms::FormField'

    store_accessor :data

    validates :registration, presence: true
    validates :template, presence: true

    validate :validate_fields

    def validate_fields
      template.fields.each do |field|
        field.validate(self)
      end unless new_record?
    end

    after_initialize :add_field_accessors

    def add_field_accessors
      self.template.fields.each do |field|
        singleton_class.class_eval { store_accessor :data, field.name }
      end
    end

  end
end
