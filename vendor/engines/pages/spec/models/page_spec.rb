require 'spec_helper'

describe Page do
  
  before(:each) do
    @page = Page.make_unsaved
  end

  context "validations" do
    
    it "should have a name" do
      @page.title = ""
      @page.valid?.should == false
    end

    it "should have a position" do
      @page.position = nil
      @page.valid?.should == false
    end

  end

end
