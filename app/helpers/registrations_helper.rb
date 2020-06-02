# == Schema Information
#
# Table name: registrations
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
#  session_id        :text
#  payment_intent_id :text
#  uuid              :string
#  completed_at      :datetime
#  abandoned_at      :datetime
#  cancelled_at      :datetime
#  checked_in_at     :datetime
#
# Indexes
#
#  index_registrations_on_credit_card_id  (credit_card_id)
#  index_registrations_on_tenant_id       (tenant_id)
#  index_registrations_on_user_id         (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (credit_card_id => credit_cards.id)
#  fk_rails_...  (form_packet_id => form_packets.id)
#  fk_rails_...  (tenant_id => tenants.id)
#  fk_rails_...  (user_id => users.id)
#  fk_rails_...  (variant_id => variants.id)
#

module RegistrationsHelper
end
