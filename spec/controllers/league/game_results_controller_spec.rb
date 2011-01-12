require 'spec_helper'

describe League::GameResultsController do

  describe "GET 'show,'" do
    it "should be successful" do
      get 'show,'
      response.should be_success
    end
  end

  describe "GET 'index,'" do
    it "should be successful" do
      get 'index,'
      response.should be_success
    end
  end

  describe "GET 'edit,'" do
    it "should be successful" do
      get 'edit,'
      response.should be_success
    end
  end

  describe "GET 'new'" do
    it "should be successful" do
      get 'new'
      response.should be_success
    end
  end

end
