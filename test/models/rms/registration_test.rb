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
#  session_id        :text
#  payment_intent_id :text
#  uuid              :string
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

require 'test_helper'

class Rms::RegistrationTest < ActiveSupport::TestCase

  setup do
    Tenant.current = tenants(:hockey_league_site)
  end

  context :validations do
    should validate_presence_of(:variant)
    should validate_presence_of(:item)
    should validate_presence_of(:first_name)
    should validate_presence_of(:last_name)
    should validate_presence_of(:email)
    should validate_presence_of(:birthdate)
    should 'not accept invalid email' do
      registration = Rms::Registration.new( email: 'foo-bar' )
      registration.valid?
      assert_equal ['is not a valid email address'], registration.errors[:email]
    end
  end

  context :associations do
    should belong_to(:tenant)
    should belong_to(:variant)
    should have_many(:forms)
  end

  context :before_create do
    should 'generate a uuid' do
      registration = Rms::Registration.new
      registration.save validate: false
      assert_not_empty registration.uuid
    end
  end

end
