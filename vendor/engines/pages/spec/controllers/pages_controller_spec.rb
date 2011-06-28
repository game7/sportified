require 'spec_helper'
require 'devise/test_helpers'
require 'cancan/matchers'

describe PagesController do
  include Devise::TestHelpers
  
  before(:each) do
    @site = Site.make
    Site.current = @site
    @page = Page.make(:site => @site)   
  end

  context 'authorizing anonymous user' do
       
    it 'should render on show' do
      get :show, :id => @page.id
      flash[:alert].should be_nil
      response.should render_template('show')
    end

    it 'should redirect to root with an alert on edit' do
      get :edit, :id => @page.id
      flash[:alert].should_not be_nil
      response.should redirect_to(root_path)
    end

  end

  context 'authorizing authenticated standard user' do
    
    before(:each) do     
      @user = User.make_unsaved
      sign_in @user
      @ability = Ability.new(@user, @site.id)
      Ability.stub(:new).and_return(@ability) 
    end

    it 'should redirect to root with an alert on edit' do
      get :edit, :id => @page.id
      flash[:alert].should_not be_nil
      response.should redirect_to(root_path)
    end
  
  end 

  context 'authorizing authenticated admin user' do
    
    before(:each) do
      @user = User.make
      @user.roles << UserRole.site_admin(@site)
      sign_in @user 
      @ability = Ability.new(@user, @site.id)
      #@ability.stub!(:can?).with(:edit, @page).and_return(true)
      Ability.stub(:new).and_return(@ability) 
    end

    it 'should render on edit' do
      get :edit, :id => @page.id
      flash[:alert].should be_nil
      response.should render_template('edit')
    end

    
  end
  
end
