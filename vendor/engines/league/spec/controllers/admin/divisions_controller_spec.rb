require 'spec_helper'

describe Admin::DivisionsController do
  
  
  
  describe 'when fetching divisions' do
    
    before(:each) do
      @ability = Object.new
      @ability.extend(CanCan::Ability)
      @controller.stub!(:current_ability).and_return(@ability)
      Site.current = Site.make
    end
    
    it "should scope results to current site" do
      division = mock_model(Division)
      Division.should_receive(:for_site).with(Site.current).and_return([division])
      get "index"
    end

    it "should get the requested division" do
      division = mock_model(Division)
      Division.should_receive(:find).with("ID").and_return(division)
      get "show", :id => "ID"
    end

  end
  
end
  
