require 'spec_helper'

describe Site do
  
  before(:each) do
    @site = Site.make_unsaved
  end

  context "validations" do
    
    it "should have a name" do
      @site.name = ""
      @site.valid?.should == false
    end

    it "should have a subdomain" do
      @site.subdomain = nil
      @site.valid?.should == false
    end

  end

end
