class Blocks::ImagesController < BlocksController
  
  def dialog
  end
  
  def edit
  end
  
  def update  
    if @block.update_attributes(blocks_image_params)
      flash[:success] = "Image updated"
    end    
  end
  
  private
  
  def blocks_image_params
    params.required(:blocks_image).permit(:link_url, :alignment, :height, :width, :image, :remote_image_url, :image_cache)
  end
  
end
