require 'spec_helper'

describe Venue do
  
  before(:each) do
    @venue = Venue.make_unsaved
  end

  describe "validations" do
    
    it { should validate_presence_of(:name) }

    it "should otherwise be valid" do
      @venue.valid?.should == true      
    end

  end

  describe 'when saved' do
    
    it "should automatically set the short name if one is not provided" do
      @venue.short_name = ''
      @venue.save
      @venue.short_name.should == @venue.name
    end

    it "should publish a message if the name has been changed" do
      @venue.save
      new_name = "new venue name"
      new_short_name = "new"
      @venue.name = new_name
      @venue.short_name = new_short_name
      MessageBus.current.should_receive(:publish).with do |*args|
        message = args.pop
        message.name.should == :venue_renamed
        message.data[:venue_id].should == @venue.id
        message.data[:new_venue_name].should == new_name
        message.data[:new_venue_short_name].should == new_short_name
        true
      end
      @venue.save      
    end

  end

end
