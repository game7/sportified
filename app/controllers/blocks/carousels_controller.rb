class Blocks::CarouselsController < BlocksController
  
  def edit

  end
  
  def update
    p blocks_carousel_params
    if @block.update_attributes(blocks_carousel_params)
      flash[:success] = "Carousel updated"
    end
  end
  
  private
  
  def blocks_carousel_params
    params.required(:blocks_carousel).permit(:post_count, :shuffle, :tags => [])
  end
  
end