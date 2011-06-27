require 'spec_helper'

describe HockeyStatsheet do
  
  before(:each) do
  
  end

  describe "validations" do

    #it "should otherwise be valid" do
    #  @season.valid?.should == true      
    #end

  end

  describe "when requesting the score by minute" do
    
    before(:each) do
      @statsheet = HockeyStatsheet.new
      @statsheet.min_1 = 15
      @statsheet.min_2 = 15
      @statsheet.min_3 = 15
    end
    
    it "should return an item for each minute of game time plus 1 minute per period" do
      score_by_minute = @statsheet.score_by_minute
      score_by_minute.length.should == 48
    end
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

  describe "when loading players" do
    
    before(:each) do
      @statsheet = HockeyStatsheet.new
      @statsheet.game = Game.make
      (0..2).each do |i|
        @statsheet.game.left_team.players << Player.make(:jersey_number => i.to_s)
      end
      (0..4).each do |i|
        @statsheet.game.right_team.players << Player.make(:jersey_number => i.to_s)
      end
      @statsheet.save
    end

    it "should load the correct number of players to the correct team" do
      @statsheet.players.left.count.should == 3      
      @statsheet.players.right.count.should == 5  
    end

    it "should incrementally add new players without reloading existing players" do
      @statsheet.game.left_team.players.each_with_index do |plr, i|
        plr.jersey_number = (20 + i).to_s
      end
      @statsheet.game.left_team.players << Player.make(:jersey_number => 3.to_s)
      @statsheet.save
      @statsheet.load_players
      @statsheet.save
      @statsheet.players.left.count.should == 4
      @statsheet.players.left.each_with_index do |plr, i|
        plr.num.should == i.to_s
      end
    end

  end

  describe "when reloading players" do
    
    before(:each) do
      @statsheet = HockeyStatsheet.new
      @statsheet.game = Game.make
      (0..2).each do |i|
        @statsheet.game.left_team.players << Player.make(:jersey_number => i.to_s)
      end
      (0..4).each do |i|
        @statsheet.game.right_team.players << Player.make(:jersey_number => i.to_s)
      end
      @statsheet.save
    end

    it "should restore the full set of players" do
      @statsheet.players.left.each_with_index do |plr, i|
        plr.num = (10 + i).to_s
      end
      @statsheet.save
      @statsheet.reload_players
      @statsheet.save
      @statsheet.players.left.each_with_index do |plr, i|
        plr.num.should == i.to_s
      end
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

    it "should update the correct players when a penalty is deleted" do
      g = @statsheet.events << @penalty
      @statsheet.events.delete(@penalty)
      @offender.pen.should == 0
      @offender.pim.should == 0   
    end

  end

  describe "when player statistics are recalculated" do
    
    before(:each) do
      @statsheet = HockeyStatsheet.new
      (1..3).each do |i|
        @statsheet.players << HockeyPlayer.make_unsaved(:side => 'left', :num => i.to_s, :g => 1, :a => 1, :pts => 2, :pen => 1, :pim => 2)
      end
      (1..3).each do |i|
        @statsheet.players << HockeyPlayer.make_unsaved(:side => 'right', :num => i.to_s, :g => 1, :a => 1, :pts => 2, :pen => 1, :pim => 2)
      end
      @statsheet.save
    end

    it "should clear each player's player's previous stats" do
      @statsheet.calculate_player_stats
      @statsheet.players.each do |plr|
        plr.g.should == 0
        plr.a.should == 0
        plr.pts.should == 0
        plr.pim.should == 0
      end
    end

    it "should properly calculate stats for a goal" do
      @statsheet.events.build({:side => 'left', :plr => "1", :a1 => "2", :a2 => "3"}, HockeyGoal)
      @statsheet.save
      @statsheet.calculate_player_stats
      @statsheet.save
      scorer = @statsheet.players.left.with_num("1").first
      assist1 = @statsheet.players.left.with_num("2").first
      assist2 = @statsheet.players.left.with_num("3").first
      scorer.g.should == 1
      scorer.pts.should == 1
      assist1.a.should == 1
      assist1.pts.should == 1
      assist2.a.should == 1
      assist2.pts.should ==	 1
    end
    
  end

end
