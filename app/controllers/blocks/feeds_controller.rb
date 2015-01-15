class Blocks::FeedsController < BlocksController
  
  def edit

  end
  
  def update
    if @block.update_attributes(blocks_feed_params)
      flash[:success] = "Feed updated"          
    end    
  end
  
  private
  
  def blocks_feed_params
    params.required(:blocks_feed).permit(:post_count, :tags)
  end  
  
end