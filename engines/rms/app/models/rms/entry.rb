# == Schema Information
#
# Table name: rms_entries
#
#  id         :integer          not null, primary key
#  form_id    :integer
#  data       :hstore
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

module Rms
  class Entry < ActiveRecord::Base
    belongs_to :form
    has_many :fields, through: :form

    validates :form, presence: true

    store_accessor :data

    validate :validate_fields

    def validate_fields
      form.fields.each do |field|
        field.validate(self)
      end
    end

    after_initialize :add_field_accessors

    def add_field_accessors
      self.form.fields.each do |field|
        singleton_class.class_eval { store_accessor :data, field.name }
      end
    end

  end
end
