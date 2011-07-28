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
    
    it "should update the starts_on date/time for all day events to 12:00 AM" do
      now = DateTime.now
      @event.starts_on = DateTime.now
      @event.all_day = true
      @event.save
      @event.starts_on.year.should == now.year
      @event.starts_on.month.should == now.month
      @event.starts_on.day.should == now.day
      @event.starts_on.hour.should == 0
      @event.starts_on.min.should == 0
    end

    it "should update the ends_on date/time for all day events to 12:00 AM of next day" do
      now = DateTime.now
      @event.starts_on = DateTime.now
      @event.all_day = true
      @event.save
      @event.ends_on.year.should == now.year
      @event.ends_on.month.should == now.month
      @event.ends_on.day.should == (now.day + 1)
      @event.ends_on.hour.should == 0
      @event.ends_on.min.should == 0
    end

    it "should update the duration all day events to 60*24 minutes" do
      now = DateTime.now
      @event.starts_on = DateTime.now
      @event.all_day = true
      @event.save
      @event.duration.should == (60 * 24)
    end
    
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
