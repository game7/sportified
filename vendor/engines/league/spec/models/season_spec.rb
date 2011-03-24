require 'spec_helper'

describe Season do
  
  before(:each) do
    @season = Season.make_unsaved
  end

  describe "validations" do
    
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:starts_on) }
    it { should validate_presence_of(:site_id) }

    it "should otherwise be valid" do
      @season.valid?.should == true      
    end

  end

end
