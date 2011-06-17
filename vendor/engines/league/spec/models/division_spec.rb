require 'spec_helper'

describe Division do
  
  before(:each) do
    @division = Division.make_unsaved
  end

  describe "validations" do
    
    it { should validate_presence_of(:name) }

    it "should otherwise be valid" do
      @division.valid?.should == true      
    end

  end

  describe "when saving" do
    
    it "should publish message if the name has been changed" do
      @division.save
      new_name = "new division name"
      @division.name = new_name
      EventBus.current.should_receive(:publish).with do |*args|
        message = args.pop
        message.name.should == :division_renamed
        message.data[:division_id].should == @division.id
        message.data[:new_name].should == new_name
        true
      end
      @division.save
      
    end
    
  end

end
