require 'spec_helper'

describe Season do
  
  before(:each) do
    @season = Season.make_unsaved
  end

  context "when validating" do
    
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:starts_on) }

  end

end