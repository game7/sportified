require 'spec_helper'

describe GameResult do
  
  before(:each) do
    @game = Game.make_unsaved
    @result = GameResult.make_unsaved
  end

  describe "validations" do
    
    it { should validate_numericality_of(:left_team_score) }
    it { should validate_numericality_of(:right_team_score) }
    
  end

  describe "when created" do
    
    it "should raise a Game Result Created event" do
      EventBus.current = InProcessEventBus.new
      EventBus.subscribe(:game_result_posted) do |event|
        @event = event
      end
      @game.save
      @game.reload
      @game.result = @result
      @game.result.save
      @event.should_not == nil
      @event.data[:game_id].should == @game.id
    end

  end

  describe "when deleted" do
    
    it "should raise a Game Result Deleted event" do
      EventBus.current = InProcessEventBus.new
      EventBus.subscribe(:game_result_deleted) do |event|
        @event = event
      end
      @game.result = @result
      @game.save
      @game.reload
      @game.result.destroy
      @event.should_not == nil
      @event.data[:game_id].should == @game.id      
    end

  end

end
