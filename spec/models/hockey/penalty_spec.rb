# == Schema Information
#
# Table name: hockey_penalties
#
#  id              :integer          not null, primary key
#  tenant_id       :integer
#  statsheet_id    :integer
#  period          :integer
#  minute          :integer
#  second          :integer
#  team_id         :integer
#  committed_by_id :integer
#  infraction      :string(255)
#  duration        :integer
#  severity        :string(255)
#  start_period    :string(255)
#  start_minute    :integer
#  start_second    :integer
#  end_period      :string(255)
#  end_minute      :integer
#  end_second      :integer
#  mongo_id        :string(255)
#  created_at      :datetime
#  updated_at      :datetime
#

require 'rails_helper'

RSpec.describe Hockey::Penalty, :type => :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
