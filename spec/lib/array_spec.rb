require 'spec_helper'

describe Array do
  
  before(:each) do
    @array = "abcdef".split("")
  end

  context "movement" do
    
    it "should move to front" do
      @array.move_to_front("f")
      @array.should == "fabcde".split("")
    end

    it "should move to back" do
      @array.move_to_back("a")
      @array.should == "bcdefa".split("")
    end

    it "should move forward" do
      @array.move_forward("b")
      @array.should == "bacdef".split("")
    end

    it "should move back" do
      @array.move_back("c")
      @array.should == "abdcef".split("")
    end

  end

  context "positioning" do
    
    it "should indicate first element" do
      @array.first?("c").should == false
      @array.first?("a").should == true
    end

    it "should indicate last element" do
      @array.last?("c").should == false
      @array.last?("f").should == true
    end
    
  end

end
