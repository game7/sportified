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
    belongs_to :template

    has_many :fields, -> {order(:position)},
                      through: :template,
                      class_name: 'Rms::FormField'

    store_accessor :data

    validates :registration_id, presence: true
    validates :template_id, presence: true

    validate :validate_fields

    def validate_fields
      form.fields.each do |field|
        field.validate(self)
      end
    end

    after_initialize :add_field_accessors

    def add_field_accessors
      self.form.form.fields.each do |field|
        singleton_class.class_eval { store_accessor :data, field.name }
      end
    end

  end
end
