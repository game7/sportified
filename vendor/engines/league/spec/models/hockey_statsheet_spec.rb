require 'spec_helper'

describe HockeyStatsheet do
  
  before(:each) do
  
  end

  describe "validations" do

    #it "should otherwise be valid" do
    #  @season.valid?.should == true      
    #end

  end

  describe "when creating events" do
    
    before(:each) do
      @statsheet = HockeyStatsheet.new
    end
    
    it "should capture the latest event time" do
      goal = HockeyGoal.make_unsaved
      @statsheet.event_created(goal)     
      @statsheet.latest_per.should == goal.per
      @statsheet.latest_min.should == goal.min
      @statsheet.latest_sec.should == goal.sec
    end

    it "should only capture the event time when greater than the currently-set event time" do
      goal = HockeyGoal.make_unsaved(:per => 3)
      @statsheet.event_created(goal) 
      goal2 = HockeyGoal.make_unsaved(:per => 2)
      @statsheet.event_created(goal2)    
      @statsheet.latest_per.should == goal.per
      @statsheet.latest_min.should == goal.min
      @statsheet.latest_sec.should == goal.sec      
    end
    
  end

  describe "when summarizing goals" do
    
    before(:each) do
      @statsheet = HockeyStatsheet.new
      ['L','R'].each do |side|
        ['1','2','3','OT'].each do |period|
          @statsheet.events << HockeyGoal.make_unsaved(:per => period, :side => side)          
        end
      end
      @statsheet.calculate_goals      
    end

    it "should provide the total number of goals" do
      @statsheet.left_goals_total.should == 4
      @statsheet.right_goals_total.should == 4
    end
    
  end

end
