require 'spec_helper'

describe StandingsLayout do
  
  before(:each) do
    @layout = StandingsLayout.make_unsaved
  end

  describe "validations" do
    
    it { should validate_presence_of(:name) }

    it "should otherwise be valid" do
      @layout.valid?.should == true      
    end

  end

end
