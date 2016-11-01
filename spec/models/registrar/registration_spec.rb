# == Schema Information
#
# Table name: registrar_registrations
#
#  id                   :integer          not null, primary key
#  tenant_id            :integer
#  user_id              :integer
#  first_name           :string
#  last_name            :string
#  email                :string
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  registration_type_id :integer
#  credit_card_id       :integer
#  payment_id           :string
#

require 'rails_helper'

RSpec.describe Registrar::Registration, :type => :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
