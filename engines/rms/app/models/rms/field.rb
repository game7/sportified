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
