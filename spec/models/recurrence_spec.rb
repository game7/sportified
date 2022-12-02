# == Schema Information
#
# Table name: recurrences
#
#  id               :bigint           not null, primary key
#  ending           :string
#  ends_on          :date
#  friday           :boolean
#  monday           :boolean
#  occurrence_count :integer
#  saturday         :boolean
#  sunday           :boolean
#  thursday         :boolean
#  tuesday          :boolean
#  wednesday        :boolean
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#
require 'rails_helper'

RSpec.describe Recurrence, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
