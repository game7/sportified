# == Schema Information
#
# Table name: registrar_sessions
#
#  id                      :integer          not null, primary key
#  tenant_id               :integer
#  registrable_id          :integer
#  registrable_type        :string
#  title                   :string(30)
#  description             :text
#  registrations_allowed   :integer
#  registrations_available :integer
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#

require 'rails_helper'

RSpec.describe Registrar::Session, :type => :model do
  it { should validate_presence_of :title }
  it { should validate_presence_of :description }
  it { should validate_length_of(:title).is_at_most(30) }
  it { should validate_numericality_of :registrations_allowed }
  it { should validate_numericality_of :registrations_available }
end
