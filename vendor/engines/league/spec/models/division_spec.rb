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

  describe "when created" do
    
    it "should not publish message that the name has been changed" do
      EventBus.current.should_not_receive(:publish).with do |*args|
        message = args.pop
        message.name.should_not == :division_renamed
        true
      end
      @division.save
      
    end

  end

  describe "when saving" do
    
    it "should publish message if the name has been changed" do
      @division.save
      new_name = "new division name"
      new_slug = new_name.parameterize
      @division.name = new_name
      EventBus.current.should_receive(:publish).with do |*args|
        message = args.pop
        message.name.should == :division_renamed
        message.data[:division_id].should == @division.id
        message.data[:division_name].should == new_name
        message.data[:division_slug].should == new_slug
        true
      end
      @division.save
      
    end
    
  end

end
