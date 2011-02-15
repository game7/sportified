require 'spec_helper'

describe Division do
  
  before(:each) do
    @division = Division.make_unsaved
  end

  describe "validations" do
    
    it "should have a name" do
      @division.name = ""
      @division.valid?.should == false
    end

  end

end
