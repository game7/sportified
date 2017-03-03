# == Schema Information
#
# Table name: hockey_statsheets
#
#  id            :integer          not null, primary key
#  tenant_id     :integer
#  posted        :boolean
#  away_score    :integer
#  home_score    :integer
#  latest_period :string
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
#  mongo_id      :string
#  created_at    :datetime
#  updated_at    :datetime
#
# Indexes
#
#  index_hockey_statsheets_on_mongo_id   (mongo_id)
#  index_hockey_statsheets_on_tenant_id  (tenant_id)
#

require 'rails_helper'

RSpec.describe Hockey::Statsheet, :type => :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
