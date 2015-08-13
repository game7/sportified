require 'rails_helper'

RSpec.describe Hockey::Skater, :type => :model do
  
  context "when instantiating" do
    
    before { @skater = Hockey::Skater.new }

    Hockey::Skater.STATS.each do |stat|
      it "has a default value of 0 for #{stat}" do
        expect(@skater.send(stat)).to equal(0)
      end
    end

  end
  
  context "when resetting" do
  
    before do
      @skater = Hockey::Skater.new
      Hockey::Skater.STATS.each do |stat|
        @skater.send("#{stat}=", 1)
      end
    end
    
    Hockey::Skater.STATS.each do |stat|
       it "sets #{stat} to 0" do
         @skater.reset
         expect(@skater.send(stat)).to equal(0)
       end
    end
    
    it "saves when calling with bang!" do
      allow(@skater).to receive(:save)
      @skater.reset!
      expect(@skater).to have_received(:save)
    end
    
  end
  
end
