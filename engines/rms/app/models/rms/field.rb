# == Schema Information
#
# Table name: rms_fields
#
#  id         :integer          not null, primary key
#  form_id    :integer
#  name       :string(40)
#  position   :integer
#  settings   :hstore
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  type       :string
#  required   :boolean
#

module Rms
  class Field < ActiveRecord::Base
    belongs_to :form

    validates :name, presence: true
    validates :type, presence: true
    validates :position, presence: true,
                         numericality: true

    def partial
      self.class.name.split('::').last.downcase
    end

    def validate(record)
        record.errors.add(name, "Can't be blank") if required? and record.data[name].blank?
    end

  end
end
