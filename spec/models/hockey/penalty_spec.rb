# == Schema Information
#
# Table name: hockey_penalties
#
#  id                  :integer          not null, primary key
#  tenant_id           :integer
#  statsheet_id        :integer
#  period              :integer
#  minute              :integer
#  second              :integer
#  team_id             :integer
#  committed_by_id     :integer
#  infraction          :string
#  duration            :integer
#  severity            :string
#  start_period        :string
#  start_minute        :integer
#  start_second        :integer
#  end_period          :string
#  end_minute          :integer
#  end_second          :integer
#  created_at          :datetime
#  updated_at          :datetime
#  committed_by_number :string
#
# Indexes
#
#  index_hockey_penalties_on_statsheet_id  (statsheet_id)
#  index_hockey_penalties_on_tenant_id     (tenant_id)
#

require 'rails_helper'

RSpec.describe Hockey::Penalty, :type => :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
