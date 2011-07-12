require 'spec_helper'

describe TeamRecord do
  
  before(:each) do

  end

  describe "validations" do
    
  end

  describe 'when posting game results' do
    
    def setup_results(left_score, right_score, completed_in = 'regulation') 
      @game = Game.make(:left_team_score => left_score, :right_team_score => right_score, :completed_in => completed_in)
      @left = @game.left_team.record
      @right = @game.right_team.record
      @left.post_result_from_game(@game)
      @right.post_result_from_game(@game)
    end   
    
    it "should be able to correctly update the scoring" do
      setup_results(5, 2)
      
      @left.scored.should == 5
      @left.allowed.should == 2
      @left.margin.should == 3

      @right.scored.should == 2
      @right.allowed.should == 5
      @right.margin.should == -3
    end

    it "should be able to correctly update the streak for a left team win" do
      setup_results(5, 2)
      
      @left.last.should == 'win'
      @left.run.should == 1
      @left.stk.should == 'Won 1'  

      @right.last.should == 'loss'
      @right.run.should == 1
      @right.stk.should == 'Lost 1'  

    end

    it "should be able to correctly update the streak for a right team win" do
      setup_results(1, 2)
      
      @left.last.should == 'loss'
      @left.run.should == 1
      @left.stk.should == 'Lost 1'  

      @right.last.should == 'win'
      @right.run.should == 1
      @right.stk.should == 'Won 1'  

    end

    it "should be able to correctly update the streak for a tie" do
      setup_results(5, 5)
      
      @left.last.should == 'tie'
      @left.run.should == 1
      @left.stk.should == 'Tied 1'  

      @right.last.should == 'tie'
      @right.run.should == 1
      @right.stk.should == 'Tied 1'  

    end
    
    it "should be able to correctly update the records for a regulation game" do
      setup_results(3, 1)
      @left.gp.should == 1
      @left.w.should == 1
      @left.l.should == 0
      @left.t.should == 0
      @left.rw.should == 1
      @left.rl.should == 0
      @left.otw.should == 0
      @left.otl.should == 0
      @left.sol.should == 0
      @left.sow.should == 0
      @left.ffl.should == 0
      @left.ffw.should == 0
      @left.pts.should == 2

      @right.gp.should == 1
      @right.w.should == 0
      @right.l.should == 1
      @right.t.should == 0
      @right.rw.should == 0
      @right.rl.should == 1
      @right.otw.should == 0
      @right.otl.should == 0
      @right.sol.should == 0
      @right.sow.should == 0
      @right.ffl.should == 0
      @right.ffw.should == 0
      @right.pts.should == 0
    end

    it "should be able to correctly update the records for a regulation tie game" do
      setup_results(2, 2)
      @left.gp.should == 1
      @left.w.should == 0
      @left.l.should == 0
      @left.t.should == 1
      @left.rw.should == 0
      @left.rl.should == 0
      @left.otw.should == 0
      @left.otl.should == 0
      @left.sol.should == 0
      @left.sow.should == 0
      @left.ffl.should == 0
      @left.ffw.should == 0
      @left.pts.should == 1

      @right.gp.should == 1
      @right.w.should == 0
      @right.l.should == 0
      @right.t.should == 1
      @right.rw.should == 0
      @right.rl.should == 0
      @right.otw.should == 0
      @right.otl.should == 0
      @right.sol.should == 0
      @right.sow.should == 0
      @right.ffl.should == 0
      @right.ffw.should == 0
      @right.pts.should == 1
    end

    it "should be able to correctly update the records for a overtime game" do
      setup_results(1, 3, 'overtime')
      @left.gp.should == 1
      @left.w.should == 0
      @left.l.should == 1
      @left.t.should == 0
      @left.rw.should == 0
      @left.rl.should == 0
      @left.otw.should == 0
      @left.otl.should == 1
      @left.sol.should == 0
      @left.sow.should == 0
      @left.ffl.should == 0
      @left.ffw.should == 0
      @left.pts.should == 1

      @right.gp.should == 1
      @right.w.should == 1
      @right.l.should == 0
      @right.t.should == 0
      @right.rw.should == 0
      @right.rl.should == 0
      @right.otw.should == 1
      @right.otl.should == 0
      @right.sol.should == 0
      @right.sow.should == 0
      @right.ffl.should == 0
      @right.ffw.should == 0
      @right.pts.should == 2
    end 

    it "should be able to correctly update the records for a shootout game" do
      setup_results(3, 1, 'shootout')
      @left.gp.should == 1
      @left.w.should == 1
      @left.l.should == 0
      @left.t.should == 0
      @left.rw.should == 0
      @left.rl.should == 0
      @left.otw.should == 0
      @left.otl.should == 0
      @left.sol.should == 0
      @left.sow.should == 1
      @left.ffl.should == 0
      @left.ffw.should == 0
      @left.pts.should == 2

      @right.gp.should == 1
      @right.w.should == 0
      @right.l.should == 1
      @right.t.should == 0
      @right.rw.should == 0
      @right.rl.should == 0
      @right.otw.should == 0
      @right.otl.should == 0
      @right.sol.should == 1
      @right.sow.should == 0
      @right.ffl.should == 0
      @right.ffw.should == 0
      @right.pts.should == 1
    end
  
  end

end
