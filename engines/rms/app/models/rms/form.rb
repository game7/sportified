# == Schema Information
#
# Table name: rms_forms
#
#  id         :integer          not null, primary key
#  name       :string(40)
#  tenant_id  :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

module Rms
  class Form < ActiveRecord::Base
    include Sportified::TenantScoped
    belongs_to :tenant
    has_many :fields
    has_many :entries

    def field_names
      fields.collect { |f| f.name }
    end

    def permitted_params
      field_names
    end

  end
end
