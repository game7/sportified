require 'spec_helper'

describe HockeyStatsheet do
  
  before(:each) do
  
  end

  describe "validations" do

    #it "should otherwise be valid" do
    #  @season.valid?.should == true      
    #end

  end

  describe "when creating or deleting events" do
    
    before(:each) do
      @statsheet = HockeyStatsheet.new
    end
    
    it "should capture the latest event time when an event is added" do
      goal = HockeyGoal.make_unsaved
      @statsheet.events << goal     
      @statsheet.latest_per.should == goal.per
      @statsheet.latest_min.should == goal.min
      @statsheet.latest_sec.should == goal.sec
    end

    it "should only capture the event time when greater than the currently-set event time" do
      goal = HockeyGoal.make_unsaved(:per => 3)
      @statsheet.events << goal
      goal2 = HockeyGoal.make_unsaved(:per => 2)
      @statsheet.events << goal2
      @statsheet.latest_per.should == goal.per
      @statsheet.latest_min.should == goal.min
      @statsheet.latest_sec.should == goal.sec      
    end

    it "should recalculate the latest event time when an event is deleted" do
      goal = HockeyGoal.make_unsaved(:per => 2)
      @statsheet.events << goal
      goal2 = HockeyGoal.make_unsaved(:per => 3)
      @statsheet.events << goal2
      @statsheet.latest_per.should == goal2.per
      @statsheet.latest_min.should == goal2.min
      @statsheet.latest_sec.should == goal2.sec 
      @statsheet.events.delete(goal2)
      @statsheet.latest_per.should == goal.per
      @statsheet.latest_min.should == goal.min
      @statsheet.latest_sec.should == goal.sec     
    end
    
  end

  describe "when summarizing goals" do
    
    before(:each) do
      @statsheet = HockeyStatsheet.new
      ['left','right'].each do |side|
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

  describe "when a goal is created or deleted" do
    
    before(:each) do
      @statsheet = HockeyStatsheet.new
      @scorer = HockeyPlayer.make_unsaved( :num => 8, :side => 'left' )
      @statsheet.players << @scorer
      @helper1 = HockeyPlayer.make_unsaved( :num => 10, :side => 'left' )
      @statsheet.players << @helper1
      @helper2 = HockeyPlayer.make_unsaved( :num => 25, :side => 'left' )
      @statsheet.players << @helper2
      @goal = HockeyGoal.make_unsaved( :side => 'left', :plr => @scorer.num, :a1 => @helper1.num, :a2 => @helper2.num)   
    end
    
    it "should be able to increment a player's goal and point total'" do
      @statsheet.increment_goals_for_player(@goal.side, @goal.plr, 1)
      @scorer.g.should == 1
      @scorer.pts.should == 1
    end

    it "should be able to increment a player's assist and point total'" do
      @statsheet.increment_assists_for_player(@goal.side, @goal.a1, 1)
      @helper1.a.should == 1
      @helper1.pts.should == 1
    end

    it "should update the correct players when a goal is built" do
      g = @statsheet.events.build(@goal.attributes, HockeyGoal)
      @scorer.g.should == 1
      @helper1.a.should == 1
      @helper2.a.should == 1
    end

    it "should update the correct players when a goal is added" do
      g = @statsheet.events << @goal
      @scorer.g.should == 1
      @helper1.a.should == 1
      @helper2.a.should == 1
    end

    it "should update teh correct players when a goal is deleted" do
      g = @statsheet.events << @goal
      @statsheet.events.delete(@goal)
      @scorer.g.should == 0
      @helper1.a.should == 0
      @helper2.a.should == 0     
    end

  end


  describe "when a penalty is created or deleted" do
    
    before(:each) do
      @statsheet = HockeyStatsheet.new
      @offender = HockeyPlayer.make_unsaved( :num => 8, :side => 'left' )
      @statsheet.players << @offender
      @penalty = HockeyPenalty.make_unsaved( :side => 'left', :plr => @offender.num )
    end
    
    it "should be able to increment a player's pen and pim total'" do
      @statsheet.increment_penalties_for_player(@penalty.side, @penalty.plr, 1, 2)
      @offender.pen.should == 1
      @offender.pim.should == 2
    end

    it "should update the correct players when a penalty is built" do
      p = @statsheet.events.build(@penalty.attributes, HockeyPenalty)
      @offender.pen.should == 1
      @offender.pim.should == 2
    end

    it "should update the correct players when a penalty is added" do
      p = @statsheet.events << @penalty
      @offender.pen.should == 1
      @offender.pim.should == 2
    end

    it "should update teh correct players when a penalty is deleted" do
      g = @statsheet.events << @penalty
      @statsheet.events.delete(@penalty)
      @offender.pen.should == 0
      @offender.pim.should == 0   
    end

  end

end
