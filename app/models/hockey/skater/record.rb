# == Schema Information
#
# Table name: hockey_skaters
#
#  id                        :integer          not null, primary key
#  assists                   :integer          default(0)
#  ejections                 :integer          default(0)
#  first_name                :string
#  game_misconduct_penalties :integer          default(0)
#  games_played              :integer          default(0)
#  goals                     :integer          default(0)
#  gordie_howes              :integer          default(0)
#  hat_tricks                :integer          default(0)
#  jersey_number             :string
#  last_name                 :string
#  major_penalties           :integer          default(0)
#  minor_penalties           :integer          default(0)
#  misconduct_penalties      :integer          default(0)
#  penalties                 :integer          default(0)
#  penalty_minutes           :integer          default(0)
#  playmakers                :integer          default(0)
#  points                    :integer          default(0)
#  type                      :string
#  created_at                :datetime
#  updated_at                :datetime
#  player_id                 :integer
#  statsheet_id              :integer
#  team_id                   :integer
#  tenant_id                 :integer
#
# Indexes
#
#  index_hockey_skaters_on_player_id     (player_id)
#  index_hockey_skaters_on_statsheet_id  (statsheet_id)
#  index_hockey_skaters_on_team_id       (team_id)
#  index_hockey_skaters_on_tenant_id     (tenant_id)
#
class Hockey::Skater::Record < Hockey::Skater
  include Stats

  def add_result(result)
    STATS.each do |stat|
      self.send("#{stat}=", self.send(stat) + (result.send(stat) || 0))
    end
  end

  def add_result!(result)
    self.add_result result
    self.save
  end

  def remove_result(result)
    STATS.each do |stat|
      self.send("#{stat}=", [self.send(stat) - (result.send(stat) || 0), 0].max)
    end
  end

  def remove_result!(result)
    self.remove_result result
    self.save
  end

  def recalculate
    self.reset
    Hockey::Skater::Result.where('player_id = ?', self.player_id).each do |result|
      add_result(result)
    end
  end

  def recalculate!
    recalculate
    save
  end

end
