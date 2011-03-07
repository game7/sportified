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

  describe "when checking for a role" do

    before(:each) do
      @user.roles.build( :name => "site_admin" )
    end

    it "should match requested role name if assigned" do
      @user.role? "site_admin"
    end

    it "should not match if role not assigned" do
      @user.role? "tool"
    end  

    it "should return roles with matching name" do
      2.times{ @user.roles.build( :name => "site_admin" ) }
      @user.roles.find_by_name(:site_admin).count.should == 3
    end

  end

end
