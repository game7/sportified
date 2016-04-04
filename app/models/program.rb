# == Schema Information
#
# Table name: programs
#
#  id          :integer          not null, primary key
#  tenant_id   :integer
#  name        :string
#  description :text
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class Program < ActiveRecord::Base
  include Sportified::TenantScoped

  belongs_to :tenant

  validates :name, presence: true

end
