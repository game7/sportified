class Blocks::FeedsController < BlocksController
  
  def edit

  end
  
  def update
    if @block.update_attributes(params[:blocks_feed])
      flash[:success] = "Feed updated"          
    end    
  end
  
end