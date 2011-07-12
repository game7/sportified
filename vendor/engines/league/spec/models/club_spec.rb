require 'spec_helper'

describe Club do
  
  before(:each) do
    @club = Club.make_unsaved
  end

  describe "validations" do
    
    it { should validate_presence_of(:name) }

    it "should otherwise be valid" do
      @club.valid?.should == true      
    end

  end

  describe 'when saved' do
    
    it "should automatically set the short name if one is not provided" do
      @club.short_name = ''
      @club.save
      @club.short_name.should == @club.name
    end

  end

end
