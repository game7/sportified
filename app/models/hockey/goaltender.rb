# == Schema Information
#
# Table name: hockey_goaltenders
#
#  id                       :integer          not null, primary key
#  type                     :string
#  tenant_id                :integer
#  team_id                  :integer
#  player_id                :integer
#  statsheet_id             :integer
#  games_played             :integer          default(0)
#  minutes_played           :integer          default(0)
#  shots_against            :integer          default(0)
#  goals_against            :integer          default(0)
#  saves                    :integer          default(0)
#  save_percentage          :float            default(0.0)
#  goals_against_average    :float            default(0.0)
#  shutouts                 :integer          default(0)
#  shootout_attempts        :integer          default(0)
#  shootout_goals           :integer          default(0)
#  shootout_save_percentage :float            default(0.0)
#  regulation_wins          :integer          default(0)
#  regulation_losses        :integer          default(0)
#  overtime_wins            :integer          default(0)
#  overtime_losses          :integer          default(0)
#  shootout_wins            :integer          default(0)
#  shootout_losses          :integer          default(0)
#  total_wins               :integer          default(0)
#  total_losses             :integer          default(0)
#  mongo_id                 :string
#  created_at               :datetime
#  updated_at               :datetime
#  jersey_number            :string
#  first_name               :string
#  last_name                :string
#

class Hockey::Goaltender < ActiveRecord::Base
  include Sportified::TenantScoped
  before_save :set_player_name

  belongs_to :player, class_name: '::Player'

  STATS = %w{ games_played minutes_played
              shots_against goals_against
              shootout_attempts shootout_goals shootout_save_percentage
              regulation_wins regulation_losses
              overtime_wins overtime_losses
              shootout_wins shootout_losses
              total_wins total_losses }

  def goals_against=(value)
    write_attribute(:goals_against, value)
    calculate_saves
    calculate_save_percentage
    calculate_goals_against_average
  end

  def shots_against=(value)
    write_attribute(:shots_against, value)
    calculate_saves
    calculate_save_percentage
  end

  def minutes_played=(value)
    write_attribute(:minutes_played, value)
    calculate_goals_against_average
  end

  def self.STATS
    STATS
  end

  def reset
    STATS.each do |stat|
      self.send("#{stat}=", 0)
    end
  end

  def reset!
    self.reset
    self.save
  end

  private

  def calculate_saves
    self.saves = self.shots_against - self.goals_against
  end

  def calculate_save_percentage
    self.save_percentage = self.shots_against.nonzero? ? self.saves.to_f / self.shots_against.nonzero? : 0
  end

  def calculate_goals_against_average
    self.goals_against_average = (self.goals_against / (self.minutes_played / 45.0) )
  end

  def set_player_name
    if self.player
      self.first_name = self.player.first_name
      self.last_name = self.player.last_name
      self.jersey_number = self.player.jersey_number
    end
  end

end
