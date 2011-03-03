require 'spec_helper'

describe Site do
  
  before(:each) do
    @site = Site.make_unsaved
  end

  context "when validating" do
    
    it "should have a name" do
      @site.name = ""
      @site.valid?.should == false
    end

    it "should have a domain" do
      @site.domain = nil
      @site.valid?.should == false
    end

  end

end
