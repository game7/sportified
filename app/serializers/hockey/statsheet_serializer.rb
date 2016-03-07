# == Schema Information
#
# Table name: hockey_statsheets
#
#  id            :integer          not null, primary key
#  tenant_id     :integer
#  posted        :boolean
#  away_score    :integer
#  home_score    :integer
#  latest_period :string(255)
#  latest_minute :integer
#  latest_second :integer
#  min_1         :integer
#  min_2         :integer
#  min_3         :integer
#  min_ot        :integer
#  away_shots_1  :integer
#  away_shots_2  :integer
#  away_shots_3  :integer
#  away_shots_ot :integer
#  home_shots_1  :integer
#  home_shots_2  :integer
#  home_shots_3  :integer
#  home_shots_ot :integer
#  mongo_id      :string(255)
#  created_at    :datetime
#  updated_at    :datetime
#

class Hockey::StatsheetSerializer < ActiveModel::Serializer
  type 'hockey/statsheet'
  attributes :id, :home_score, :away_score
  has_many :skaters
  has_many :goaltenders
  has_many :goals
  has_many :penalties
end
