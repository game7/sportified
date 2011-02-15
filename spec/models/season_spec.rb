require 'spec_helper'

describe Season do
  
  before(:each) do
    @season = Season.make_unsaved
  end

  describe "validations" do
    
    it "should have a name" do
      @season.name = ""
      @season.valid?.should == false
    end

    it "should have a starts on date" do
      @season.starts_on = nil
      @season.valid?.should == false
    end

  end

end
