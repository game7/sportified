class TextBlocksController < BasePagesController
  
  def edit
    @block = @page.blocks.find(params[:id])    
  end

  def update
    @block = @page.blocks.find(params[:id])
    if @block.update_attributes(params[:text_block])
      flash[:notice] = "Text Block updated"          
    end
  end

end
