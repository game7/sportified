# == Schema Information
#
# Table name: hockey_goaltenders
#
#  id                       :integer          not null, primary key
#  first_name               :string
#  games_played             :integer          default(0)
#  goals_against            :integer          default(0)
#  goals_against_average    :float            default(0.0)
#  jersey_number            :string
#  last_name                :string
#  minutes_played           :integer          default(0)
#  overtime_losses          :integer          default(0)
#  overtime_wins            :integer          default(0)
#  regulation_losses        :integer          default(0)
#  regulation_wins          :integer          default(0)
#  save_percentage          :float            default(0.0)
#  saves                    :integer          default(0)
#  shootout_attempts        :integer          default(0)
#  shootout_goals           :integer          default(0)
#  shootout_losses          :integer          default(0)
#  shootout_save_percentage :float            default(0.0)
#  shootout_wins            :integer          default(0)
#  shots_against            :integer          default(0)
#  shutouts                 :integer          default(0)
#  total_losses             :integer          default(0)
#  total_wins               :integer          default(0)
#  type                     :string
#  created_at               :datetime
#  updated_at               :datetime
#  player_id                :integer
#  statsheet_id             :integer
#  team_id                  :integer
#  tenant_id                :integer
#
# Indexes
#
#  index_hockey_goaltenders_on_player_id     (player_id)
#  index_hockey_goaltenders_on_statsheet_id  (statsheet_id)
#  index_hockey_goaltenders_on_team_id       (team_id)
#  index_hockey_goaltenders_on_tenant_id     (tenant_id)
#
class Hockey::Goaltender < ActiveRecord::Base
  include Sportified::TenantScoped

  before_save :set_player_name

  belongs_to :player, class_name: '::Player', required: false

  STATS = %w{ games_played
              minutes_played
              shots_against
              goals_against
              shootout_attempts
              shootout_goals
              shootout_save_percentage
              regulation_wins
              regulation_losses
              overtime_wins
              overtime_losses
              shootout_wins
              shootout_losses
              total_wins
              total_losses }

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
    STATS.each{|stat| send("#{stat}=", 0) }
  end

  def reset!
    reset
    save
  end

  private

    def calculate_saves
      self.saves = shots_against - goals_against
    end

    def calculate_save_percentage
      self.save_percentage = shots_against.nonzero? ? saves.to_f / shots_against.nonzero? : 0
    end

    def calculate_goals_against_average
      self.goals_against_average = (goals_against / (minutes_played / 45.0) )
    end

    def set_player_name
      return if player.blank?
      self.first_name     = player.first_name
      self.last_name      = player.last_name
      self.jersey_number  = player.jersey_number
    end

end
