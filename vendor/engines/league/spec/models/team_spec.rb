require 'spec_helper'

describe Team do
  
  before(:each) do
    @team = Team.make_unsaved
  end

  describe "validations" do
    
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:season_id) }
    it { should validate_presence_of(:division_id) }

    it "should otherwise be valid" do
      @team.valid?.should == true      
    end

  end

  describe 'when saved' do
    
    it "should automatically set the short name if one is not provided" do
      @team.short_name = ''
      @team.save
      @team.short_name.should == @team.name
    end

    it "should update the division name" do
      @team.save
      @team.division_name.should == @team.division.name
    end
    
    it "should update the season name" do
      @team.save
      @team.season_name.should == @team.season.name
    end

    it "should ensure that a record is created" do
      @team.record = nil
      @team.save
      @team.record.class.should == TeamRecord
    end

  end

end
