class DocumentBlocksController < BasePagesController
  
  def edit
    @block = @page.blocks.find(params[:id])    
  end

  def update
    @block = @page.blocks.find(params[:id])
    if @block.update_attributes(params[:document_block])
      flash[:notice] = "Document updated"          
    end
    render 'update', :layout => 'script'
  end

end
