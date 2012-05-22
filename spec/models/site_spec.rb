require 'spec_helper'

describe Site do
  
  before(:each) do
    @site = Site.make_unsaved
  end

  context "when validating" do
    
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:host) }

  end

end