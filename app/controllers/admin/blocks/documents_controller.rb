class Admin::Blocks::DocumentsController < Admin::Blocks::BaseController
  
  def dialog
  end
  
  def edit
  end
  
  def update
    if @block.update_attributes(params[:blocks_document])
      flash[:success] = "Document updated"
      redirect_to admin_page_blocks_path(@page)
    end    
  end
  
end
