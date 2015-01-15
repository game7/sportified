class Blocks::DocumentsController < BlocksController
  
  def dialog
  end
  
  def edit
  end
  
  def update
    if @block.update_attributes(blocks_document_params)
      flash[:success] = "Document updated"
    end
  end
  
  private
  
  def blocks_document_params
    params.required(:blocks_document).permit(:title, :description, :file, :file_cache)
  end
  
end
