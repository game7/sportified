require 'spec_helper'

describe Game do
  
  before(:each) do
    @game = Game.make_unsaved
  end

  describe "validations" do
    
    it { should validate_presence_of(:starts_on) }
    it { should validate_presence_of(:season_id) }

    it "should otherwise be valid" do
      @game.valid?.should == true      
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

    it "should update the venue names" do
      @game.venue = Venue.make(:short_name => 'shorty')
      @game.venue_name.should == nil
      @game.save
      @game.venue_name.should == @game.venue.name
      @game.venue_short_name.should == @game.venue.short_name
    end

  end

  describe "when transitioning to final" do
    
    it "should publish a message" do
      @game.save
      @game.completed_in = "regulation"
      MessageBus.current.should_receive(:publish).with do |*args|
        message = args.pop
        message.name.should == :game_finalized
        message.data[:game_id].should == @game.id
        true
      end
      @game.finalize!
    end
    
  end

  describe "when transitioning from final" do
    
    it "should publish a message" do
      @game.save
      @game.state = "final"
      MessageBus.current.should_receive(:publish).with do |*args|
        message = args.pop
        message.name.should == :game_unfinalized
        message.data[:game_id].should == @game.id
        true
      end
      @game.complete!      
    end
  end


  describe 'when finding opponent for a team' do
    
    it "should correctly return the opponent's id" do
      @game.opponent_id(@game.left_team_id).should == @game.right_team_id
      @game.opponent_id(@game.right_team_id).should == @game.left_team_id
    end

    it "should correctly return the opponent's name" do
      @game.opponent_name(@game.left_team_id).should == @game.right_team_name
      @game.opponent_name(@game.right_team_id).should == @game.left_team_name      
    end

    it "should correctly return the opponent" do
      @game.opponent(@game.left_team_id).should == @game.right_team
      @game.opponent(@game.right_team_id).should == @game.left_team      
    end

    
  end

end
