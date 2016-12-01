# == Schema Information
#
# Table name: hockey_skaters
#
#  id                        :integer          not null, primary key
#  type                      :string
#  tenant_id                 :integer
#  team_id                   :integer
#  player_id                 :integer
#  statsheet_id              :integer
#  jersey_number             :string
#  games_played              :integer          default(0)
#  goals                     :integer          default(0)
#  assists                   :integer          default(0)
#  points                    :integer          default(0)
#  penalties                 :integer          default(0)
#  penalty_minutes           :integer          default(0)
#  minor_penalties           :integer          default(0)
#  major_penalties           :integer          default(0)
#  misconduct_penalties      :integer          default(0)
#  game_misconduct_penalties :integer          default(0)
#  hat_tricks                :integer          default(0)
#  playmakers                :integer          default(0)
#  gordie_howes              :integer          default(0)
#  ejections                 :integer          default(0)
#  mongo_id                  :string
#  created_at                :datetime
#  updated_at                :datetime
#  first_name                :string
#  last_name                 :string
#

class Hockey::Skater::Record < Hockey::Skater

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
