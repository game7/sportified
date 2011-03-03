require 'spec_helper'

describe User do
  
  before(:each) do
    @user = User.make_unsaved
  end

  context "when validating" do
    
    it "should have a name" do
      @user.name = ""
      @user.valid?.should == false
    end
    
    it "should have an email" do
      @user.email = ""
      @user.valid?.should == false
    end

  end

  context "when signing in" do
    
    it "should capture site of sign in"

  end

end
