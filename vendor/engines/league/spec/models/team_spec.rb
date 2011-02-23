require 'spec_helper'

describe Team do
  
  before(:each) do
    @team = Team.make_unsaved
  end

  describe "validations" do
    
    it "should have a name" do
      @team.name = ""
      @team.valid?.should == false
    end

    it "should belong to a division" do
      @team.division = nil
      @team.valid?.should == false
    end

    it "should belong to a season" do
      @team.season = nil
      @team.valid?.should == false
    end

  end

end
