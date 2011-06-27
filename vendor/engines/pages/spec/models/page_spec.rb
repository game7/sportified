require 'spec_helper'

describe Page do
  
  before(:each) do
    @page = Page.make_unsaved
    5.times { Block.make_unsaved(:page => @page) }
  end

  context "when validating" do
    
    it "should have a name" do
      @page.title = ""
      @page.valid?.should == false
    end

    #it "should have a position" do
    #  @page.position = nil
    #  @page.valid?.should == false
    #end

    it "should otherwise be valid" do
      @page.valid?.should == true
    end

  end

  context "when saving a page" do
    
    it "should generate a slug based from the title" do
      @page.save
      @page.slug.should == @page.title.parameterize
    end

    it "should determine the path based on the tree" do
      @parent = Page.make
      @page.parent = @parent
      @page.save
      @page.path.should == @page.ancestors_and_self.collect(&:slug).join("/")
    end

    it "should generate a tree value for sorting" do
      root = Page.make
      parent = Page.make
      parent.parent = root
      parent.save
      @page.parent = parent
      @page.save
      @page.tree.should == root.position.to_s << parent.position.to_s << @page.position.to_s
    end

    
  end

end
