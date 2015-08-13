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
