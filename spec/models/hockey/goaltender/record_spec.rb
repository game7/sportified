require 'rails_helper'

RSpec.describe Hockey::Goaltender::Record, :type => :model do

  def set_stats(obj, val)
    Hockey::Goaltender.STATS.each do |stat|
      obj.send("#{stat}=", val)
    end    
  end
  
  context "when adding results" do
  
    before do
      @record = Hockey::Goaltender::Record.new
      @result = Hockey::Goaltender::Result.new
      set_stats @result, 1
      set_stats @record, 5
    end
    
    Hockey::Goaltender.STATS.each do |stat|
       it "increments #{stat} according to result" do
         @record.add_result @result
         expect(@record.send(stat)).to eq(6)
       end
    end
    
    Hockey::Goaltender.STATS.each do |stat|
      it "decrements #{stat} according to result" do
       @record.remove_result(@result)
       expect(@record.send(stat)).to eq(4)
      end
    end
    
    context "and when decrementing" do
    
      before do
        set_stats @result, 3
        set_stats @record, 1
      end
      
      Hockey::Goaltender.STATS.each do |stat|
        it "decrements #{stat} only to 0" do
         @record.remove_result(@result)
         expect(@record.send(stat)).to eq(0)
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
