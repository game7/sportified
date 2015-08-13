require 'rails_helper'

RSpec.describe Hockey::Skater::Record, :type => :model do

  def set_stats(obj, val)
    Hockey::Skater.STATS.each do |stat|
      obj.send("#{stat}=", val)
    end    
  end
  
  context "when adding results" do
  
    before do
      @record = Hockey::Skater::Record.new
      @result = Hockey::Skater::Result.new
      set_stats @result, 1
      set_stats @record, 5
    end
    
    Hockey::Skater.STATS.each do |stat|
       it "increments #{stat} according to result" do
         @record.add_result @result
         expect(@record.send(stat)).to equal(6)
       end
    end
    
    Hockey::Skater.STATS.each do |stat|
      it "decrements #{stat} according to result" do
       @record.remove_result(@result)
       expect(@record.send(stat)).to equal(4)
      end
    end
    
    context "and when decrementing" do
    
      before do
        set_stats @result, 3
        set_stats @record, 1
      end
      
      Hockey::Skater.STATS.each do |stat|
        it "decrements #{stat} only to 0" do
         @record.remove_result(@result)
         expect(@record.send(stat)).to equal(0)
        end
      end
    
    end
    
    it "saves when calling add_result with bang!" do
      allow(@record).to receive(:save)
      @record.add_result! @result
      expect(@record).to have_received(:save)
    end
    
    it "saves when calling remove_result with bang!" do
      allow(@record).to receive(:save)
      @record.remove_result! @result
      expect(@record).to have_received(:save)
    end    
    
  end
  
end
