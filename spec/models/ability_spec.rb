require 'spec_helper'

describe Ability do
  
  before(:each) do
    @user = User.make_unsaved
    @site = Site.make_unsaved
    @other_site = Site.make_unsaved
  end

  describe "when checking with no scope" do
    
    it "should allow super admin to manage site" do
      make_super @user
      ability = Ability.new @user
      ability.can?(:manage, Site).should == true
    end

    it "should not allow site admin to manage site" do
      make_admin @user, @site
      ability = Ability.new @user
      ability.can?(:manage, @site).should == false     
    end

    it "should not allow anonymous user to manage site" do
      ability = Ability.new @user
      ability.can?(:manage, @site).should == false  
    end

  end

  context "when checking within scope of site" do
    
    it "should allow super admin to manage site" do
      make_super @user
      ability = Ability.new @user, @site
      ability.can?(:manage, @site).should == true
    end
      
    it "should allow site admin to edit site" do
      make_admin @user, @site
      ability = Ability.new @user, @site
      ability.can?(:edit, @site).should == true
    end

    it "should not allow site admin to edit other site" do
      make_admin @user, @site
      ability = Ability.new @user, @other_site
      ability.can?(:edit, @other_site).should == false
    end

    it "should not allow anonymous user to manange site" do
      ability = Ability.new @user, @site
      ability.can?(:edit, @site).should == false
    end

  end

  def make_super(user)
    user.roles.build( :name => "super_admin" )
  end

  def make_admin(user, site)
    user.roles.build( :name => "site_admin", :site_id => site.id )
  end

end
