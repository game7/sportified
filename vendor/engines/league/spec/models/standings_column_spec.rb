require 'spec_helper'

describe StandingsColumn do
  
  before(:each) do
    @column = StandingsColumn.make_unsaved
  end

  describe "validations" do
    
    it { should validate_presence_of(:title) }
    it { should validate_presence_of(:field_name) }
    it { should validate_presence_of(:description) }

    it "should otherwise be valid" do
      @column.valid?.should == true      
    end

  end

end
