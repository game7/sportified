require 'spec_helper'

describe Tenant do
  
  before(:each) do
    @tenant = Tenant.make_unsaved
  end

  context "when validating" do

    it { should validate_presence_of(:host) }

  end

end