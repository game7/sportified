# == Schema Information
#
# Table name: league_teams
#
#  id                  :integer          not null, primary key
#  name                :string
#  short_name          :string
#  slug                :string
#  show_in_standings   :boolean
#  pool                :string
#  seed                :integer
#  tenant_id           :integer
#  division_id         :integer
#  season_id           :integer
#  club_id             :integer
#  logo                :string
#  primary_color       :string
#  secondary_color     :string
#  accent_color        :string
#  main_colors         :text             default([]), is an Array
#  custom_colors       :boolean
#  crop_x              :integer          default(0)
#  crop_y              :integer          default(0)
#  crop_h              :integer          default(0)
#  crop_w              :integer          default(0)
#  mongo_id            :string
#  created_at          :datetime
#  updated_at          :datetime
#  games_played        :integer
#  wins                :integer
#  losses              :integer
#  ties                :integer
#  overtime_wins       :integer
#  overtime_losses     :integer
#  shootout_wins       :integer
#  shootout_losses     :integer
#  forfeit_wins        :integer
#  forfeit_losses      :integer
#  points              :integer
#  percent             :float
#  scored              :integer
#  allowed             :integer
#  margin              :integer
#  last_result         :string
#  current_run         :integer
#  longest_win_streak  :integer
#  longest_loss_streak :integer
#

require 'rails_helper'

RSpec.describe League::Team, :type => :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
