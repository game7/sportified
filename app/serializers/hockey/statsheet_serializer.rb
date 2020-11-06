# == Schema Information
#
# Table name: hockey_statsheets
#
#  id            :integer          not null, primary key
#  away_score    :integer
#  away_shots_1  :integer
#  away_shots_2  :integer
#  away_shots_3  :integer
#  away_shots_ot :integer
#  home_score    :integer
#  home_shots_1  :integer
#  home_shots_2  :integer
#  home_shots_3  :integer
#  home_shots_ot :integer
#  latest_minute :integer
#  latest_period :string
#  latest_second :integer
#  min_1         :integer
#  min_2         :integer
#  min_3         :integer
#  min_ot        :integer
#  posted        :boolean
#  created_at    :datetime
#  updated_at    :datetime
#  tenant_id     :integer
#
# Indexes
#
#  index_hockey_statsheets_on_tenant_id  (tenant_id)
#
class Hockey::StatsheetSerializer < ActiveModel::Serializer
  type 'hockey/statsheet'
  attributes :id,
            :tenant_id ,
            :posted,
            :away_score,
            :home_score,
            :latest_period,
            :latest_minute,
            :latest_second,
            :min_1 ,
            :min_2 ,
            :min_3 ,
            :min_ot,
            :away_shots_1,
            :away_shots_2,
            :away_shots_3,
            :away_shots_ot,
            :home_shots_1,
            :home_shots_2,
            :home_shots_3,
            :home_shots_ot,
            :created_at,
            :updated_at
  # has_many :skaters
  # has_many :goaltenders
  # has_many :goals
  # has_many :penalties
end
