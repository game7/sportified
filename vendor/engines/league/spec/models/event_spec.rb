require 'spec_helper'

describe Event do
  
  before(:each) do
    @event = Event.make_unsaved
  end

  describe "validations" do
    
    it { should validate_presence_of(:starts_on) }
    it { should validate_presence_of(:season_id) }
    it { should validate_presence_of(:duration) }

    it "should otherwise be valid" do
      @event.valid?.should == true      
    end

  end

  describe "when saving" do
    
    it "should update the end time" do
      @event.save
      @event.ends_on.should == @event.starts_on.advance(:minutes => @event.duration)
    end
    
    it "should update the venue names" do
      @event.venue = Venue.make(:short_name => 'shorty')
      @event.venue_name.should == nil
      @event.save
      @event.venue_name.should == @event.venue.name
      @event.venue_short_name.should == @event.venue.short_name
    end

  end


end
