require 'spec_helper'

describe Page do
  
  before(:each) do
    @page = Page.make_unsaved
  end

  describe "validations" do
    
    it "should have a name" do
      @page.title = ""
      @page.valid?.should == false
    end

  end

end
