# == Schema Information
#
# Table name: hockey_penalties
#
#  id                  :integer          not null, primary key
#  committed_by_number :string
#  duration            :integer
#  end_minute          :integer
#  end_period          :string
#  end_second          :integer
#  infraction          :string
#  minute              :integer
#  period              :string
#  second              :integer
#  severity            :string
#  start_minute        :integer
#  start_period        :string
#  start_second        :integer
#  created_at          :datetime
#  updated_at          :datetime
#  committed_by_id     :integer
#  statsheet_id        :integer
#  team_id             :integer
#  tenant_id           :integer
#
# Indexes
#
#  index_hockey_penalties_on_statsheet_id  (statsheet_id)
#  index_hockey_penalties_on_tenant_id     (tenant_id)
#
class Hockey::PenaltySerializer < ActiveModel::Serializer
  attributes :id, 
            :period, 
            :minute, 
            :second, 
            :team_id,
            :committed_by_id,
            :infraction, 
            :duration, 
            :severity, 
            :start_period, 
            :start_minute, 
            :start_second, 
            :end_period, 
            :end_minute, 
            :end_second,
            :created_at,
            :updated_at
  # belongs_to :team
  # belongs_to :committed_by
end
