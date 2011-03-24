require 'spec_helper'

describe Game do
  
  before(:each) do
    @game = Game.make_unsaved
  end

  describe "validations" do
    
    it { should validate_presence_of(:starts_on) }
    it { should validate_presence_of(:season_id) }
    it { should validate_presence_of(:site_id) }

    it "should otherwise be valid" do
      @game.valid?.should == true      
    end

  end

  describe "when asking about game result" do
    
    it "should not allow result to be added when game has not yet occurred" do
      @game.starts_on = @game.starts_on + 1
      @game.can_add_result?.should == false
    end

    it "should allow result to be added when game has already occurred" do
      @game.starts_on = @game.starts_on - 1
      @game.can_add_result?.should == true
    end

    it "should not allow result to be added when a result already exists" do
      @game.starts_on = @game.starts_on - 1
      @game.result = GameResult.make_unsaved
      @game.can_add_result?.should == false
    end

    it "should not allow game result to be deleted when it does not exist" do
      @game.can_delete_result?.should == false
    end
 
    it "should allow result to be deleted when it exists" do
      @game.result = GameResult.make_unsaved
      @game.can_delete_result?.should == true
    end
   
  end

  describe "when saving" do
    
    it "should update the left team name" do
      @game.left_team_name.should == nil
      @game.save
      @game.left_team_name.should == @game.left_team.name
    end

    it "should update the right team name" do
      @game.right_team_name.should == nil
      @game.save
      @game.right_team_name.should == @game.right_team.name
    end

  end

end
