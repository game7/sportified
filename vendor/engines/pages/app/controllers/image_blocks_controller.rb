class ImageBlocksController < BasePagesController
  
  def edit
    @block = @page.blocks.find(params[:id])    
  end

  def update
    @block = @page.blocks.find(params[:id])
    if @block.update_attributes(params[:image_block])
      flash[:notice] = "Image updated"          
    end
    render 'update', :layout => 'script'
  end

end
