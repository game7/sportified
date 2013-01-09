class Blocks::CarouselsController < BlocksController
  
  def edit

  end
  
  def update
    if @block.update_attributes(params[:blocks_carousel])
      flash[:success] = "Carousel updated"          
    end    
  end
  
end