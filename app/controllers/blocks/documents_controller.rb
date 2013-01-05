class Blocks::DocumentsController < BlocksController
  
  def dialog
  end
  
  def edit
  end
  
  def update
    if @block.update_attributes(params[:blocks_document])
      flash[:success] = "Document updated"
    end    
  end
  
end
