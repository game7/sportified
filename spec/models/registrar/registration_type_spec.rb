# == Schema Information
#
# Table name: registrar_registration_types
#
#  id                   :integer          not null, primary key
#  tenant_id            :integer
#  registrar_session_id :integer
#  title                :string(30)
#  description          :text
#  price                :decimal(20, 4)
#  quantity_allowed     :integer
#  quantity_available   :integer
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#

require 'rails_helper'

RSpec.describe Registrar::RegistrationType, :type => :model do

  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:description) }
  it { should validate_length_of(:title).is_at_most(30) }
  it { should validate_numericality_of(:quantity_allowed) }
  it { should validate_numericality_of(:quantity_available) }
  it { should validate_numericality_of(:price).is_greater_than_or_equal_to(0) }

end
