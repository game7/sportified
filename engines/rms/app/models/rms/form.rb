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
  end
end
