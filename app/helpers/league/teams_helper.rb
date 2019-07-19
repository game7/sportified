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
# Indexes
#
#  index_league_teams_on_club_id      (club_id)
#  index_league_teams_on_division_id  (division_id)
#  index_league_teams_on_season_id    (season_id)
#  index_league_teams_on_tenant_id    (tenant_id)
#

module League::TeamsHelper

  def display_event_summary(event, team)
    event.class.to_s == "Game" && event.has_team?(@team) ? "#{event.home_team == @team ? 'vs' : 'at'} #{event.opponent_name(@team)}" : event.summary
  end

  def display_time_or_result(event, team)
    if event.class.to_s == "Game" && event.display_score? && event.has_team?(team)
      display_result(event, team)
    else
      event.all_day ? "All Day" : event.starts_on.strftime('%l:%M %p')
    end
  end

  def display_result(game, team)
    if game.display_score?
      postfix = ''
      postfix = ' (SO)' if game.completion.shootout?
      postfix = ' (Forfeit)' if game.completion.forfeit?
      postfix = ' (OT)' if game.completion.overtime?
      "#{game.team_decision(team)} #{game.team_scored(team)}-#{game.team_allowed(team)}#{postfix}"
    end
  end

end
