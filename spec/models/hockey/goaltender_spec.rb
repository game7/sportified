# == Schema Information
#
# Table name: hockey_goaltenders
#
#  id                       :integer          not null, primary key
#  type                     :string(255)
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
#  mongo_id                 :string(255)
#  created_at               :datetime
#  updated_at               :datetime
#  jersey_number            :string(255)
#  first_name               :string(255)
#  last_name                :string(255)
#

require 'rails_helper'

RSpec.describe Hockey::Goaltender, :type => :model do
  
  context "when validating" do
    
    
    
  end

  context "when calculating statistics" do
    
    before { @goalie = Hockey::Goaltender.new }
    
    it "should calculate saves" do
      @goalie.shots_against = 10
      @goalie.goals_against = 2
      expect(@goalie.saves).to equal(8)
    end
    
    it "should calculate the Save Percentage" do
      @goalie.shots_against = 10
      @goalie.goals_against = 1
      expect(@goalie.save_percentage).to equal(0.9)
    end
    
    it "should have a Save Percentage of zero when shots and goals are zero" do
      @goalie.shots_against = 0
      @goalie.goals_against = 0
      expect(@goalie.save_percentage).to equal(0.0)
    end
    
    it "should calculate the Goals Against Average" do
      @goalie.minutes_played = 90
      @goalie.goals_against = 3
      expect(@goalie.goals_against_average).to equal(1.5)
    end
    
    it "should calculate the Goals Against Average when no goals allowed" do
      @goalie.minutes_played = 60
      @goalie.goals_against = 0
      expect(@goalie.goals_against_average).to equal(0.0)      
    end
    
  end
end
