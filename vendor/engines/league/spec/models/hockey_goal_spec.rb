require 'spec_helper'

describe HockeyGoal do
       
  before(:each) do
    @goal = HockeyGoal.make_unsaved
  end

  describe "validations" do
    
    it { should validate_presence_of(:per) }
    it { should validate_presence_of(:min) }
    it { should validate_presence_of(:sec) }
    it { should validate_presence_of(:side) }
    it { should validate_presence_of(:plr) }

    it "should otherwise be valid" do
      @goal.valid?.should == true      
    end

  end

end
