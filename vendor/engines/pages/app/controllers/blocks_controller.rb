class BlocksController < ApplicationController
  
  before_filter :load_page
  before_filter :load_block, :only => [:destroy]

  def load_page
    @page = Page.find(params[:page_id])
  end

  def load_block
    @block = @page.blocks.find(params[:id])   
  end


  def index
    @blocks_for_panel = @page.blocks_grouped_by_panel
  end

  def position
    
    @page.blocks.each do |block|
      if params['block'] && pos = params['block'].index(block.id.to_s)
        block.position = pos
        block.layout_id = params['layout_id']
        block.panel_id = params['panel_id']
      end
    end    
    @page.save
    render :nothing => true

  end

  def create
    @block = @page.blocks.create({:layout_id => params[:layout_id], :panel_id => params[:panel_id]}, params[:block_type].constantize) 
    flash[:notice] = "Block Added"
  end

  
  def destroy
    @block.delete    
    flash[:notice] = "Block Deleted"
  end

end
