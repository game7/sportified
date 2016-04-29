# == Schema Information
#
# Table name: hockey_goals
#
#  id                      :integer          not null, primary key
#  tenant_id               :integer
#  statsheet_id            :integer
#  period                  :integer
#  minute                  :integer
#  second                  :integer
#  team_id                 :integer
#  scored_by_id            :integer
#  scored_on_id            :integer
#  assisted_by_id          :integer
#  also_assisted_by_id     :integer
#  strength                :string
#  mongo_id                :string
#  created_at              :datetime
#  updated_at              :datetime
#  scored_by_number        :string
#  assisted_by_number      :string
#  also_assisted_by_number :string
#

require 'rails_helper'

RSpec.describe Hockey::Goal, :type => :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
