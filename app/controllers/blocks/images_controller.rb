class Blocks::ImagesController < Blocks::BaseController
  
  def dialog
  end
  
  def edit
  end
  
  def update
    if @block.update_attributes(params[:blocks_image])
      flash[:success] = "Image updated"
    end    
  end
  
end
