require 'spec_helper'

describe Page do
  
  before(:each) do
    @page = Page.make_unsaved
    5.times { Block.make_unsaved(:page => @page) }
  end

  context "validations" do
    
    it "should have a name" do
      @page.title = ""
      @page.valid?.should == false
    end

    it "should have a position" do
      @page.position = nil
      @page.valid?.should == false
    end

  end

  context "when moving blocks" do
    
    it "should be able to move a block up/forward" do
      block = @page.blocks[3]
      block.move_up
      block.should == @page.blocks[2]
    end

    it "should be able to move a block down/back" do
      block = @page.blocks[1]
      block.move_down
      block.should == @page.blocks[2]
    end

    it "should be able to move a block to the top/front" do
      block = @page.blocks[3]
      block.move_to_top
      block.should == @page.blocks[0]
    end

    it "should be able to move a block to the bottom/back" do
      block = @page.blocks[1]
      block.move_to_bottom
      block.should == @page.blocks[4]      
    end

  end

  context "when saving a page" do
    
    it "should generate a slug based from the title" do
      @page.save
      @page.slug.should == @page.title.parameterize
    end

    it "should datermine the path based on the tree" do
      @parent = Page.make
      @page.parent = @parent
      @page.save
      @page.path.should == @page.ancestors_and_self.collect(&:slug).join("/")
    end

    it "should assign a group and level based on the tree" do
      root = Page.make
      parent = Page.make
      root.children << parent
      parent.children << @page
      @page.save
      @page.group.should == root.group
      @page.level.should == 2
    end

    it "should update the position of all blocks" do
      @page.blocks[2].move_to_top
      @page.blocks[1].move_to_bottom
      @page.save
      @page.blocks.each_with_index{ |block, index| block.position.should == index }
    end
    
  end

end
