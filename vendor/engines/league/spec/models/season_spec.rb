require 'spec_helper'

describe Season do
  
  before(:each) do
    @season = Season.make_unsaved
  end

  describe "validations" do
    
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:starts_on) }

    it "should otherwise be valid" do
      @season.valid?.should == true      
    end

  end

  describe "when created" do
    
    it "should not publish message that the name has been changed" do
      EventBus.current.should_not_receive(:publish).with do |*args|
        message = args.pop
        message.name.should_not == :season_renamed
        true
      end
      @season.save
      
    end

  end

  describe "when saved" do
    
    it "should publish message if the name has been changed" do
      @season.save
      new_name = "new season name"
      @season.name = new_name
      EventBus.current.should_receive(:publish).with do |*args|
        message = args.pop
        message.name.should == :season_renamed
        message.data[:season_id].should == @season.id
        message.data[:new_name].should == new_name
        true
      end
      @season.save
      
    end
    
  end

end
