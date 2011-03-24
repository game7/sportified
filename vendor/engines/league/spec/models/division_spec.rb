require 'spec_helper'

describe Division do
  
  before(:each) do
    @division = Division.make_unsaved
  end

  describe "validations" do
    
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:site_id) }

    it "should otherwise be valid" do
      @division.valid?.should == true      
    end

  end

end
