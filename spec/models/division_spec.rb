require 'spec_helper'

describe Division do
  
  before(:each) do
    @division = Division.make
  end

  describe "validations" do
    
    it "should have a title" do
      @division.title = ""
      @division.valid?.should == false
    end

  end

end
