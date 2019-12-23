# == Schema Information
#
# Table name: rms_registrations
#
#  id                :integer          not null, primary key
#  tenant_id         :integer
#  user_id           :integer
#  variant_id        :integer
#  credit_card_id    :integer
#  first_name        :string(40)
#  last_name         :string(40)
#  email             :string
#  payment_id        :string
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  price             :decimal(20, 4)
#  form_packet_id    :integer
#  confirmation_code :string
#  birthdate         :date
#
# Indexes
#
#  index_rms_registrations_on_credit_card_id  (credit_card_id)
#  index_rms_registrations_on_tenant_id       (tenant_id)
#  index_rms_registrations_on_user_id         (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (credit_card_id => credit_cards.id)
#  fk_rails_...  (form_packet_id => rms_form_packets.id)
#  fk_rails_...  (tenant_id => tenants.id)
#  fk_rails_...  (user_id => users.id)
#  fk_rails_...  (variant_id => rms_variants.id)
#

module Rms
  module RegistrationsHelper
  end
end