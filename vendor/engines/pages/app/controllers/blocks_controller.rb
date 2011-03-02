class BlocksController < ApplicationController
  
  before_filter :load_page, :load_block

  def load_page
    @page = Page.find(params[:page_id])
  end

  def load_block
    @block = @page.blocks.find(params[:id])   
  end

  def move_top
    @block.move_to_top
    @page.save
  end

  def move_up
    @block.move_up
    @page.save
  end

  def move_down
    @block.move_down
    @page.save    
  end

  def move_bottom
    @block.move_to_bottom
    @page.save
  end

  
  def destroy
    @block.delete    
    flash[:notice] = "Block Deleted"
  end

end
