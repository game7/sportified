require 'spec_helper'

describe League do

  context "when validating" do

    it { should validate_presence_of(:name) }

  end

end