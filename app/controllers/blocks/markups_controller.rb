class Blocks::MarkupsController < BlocksController
  
  def edit
  end
  
  def update
    if @block.update_attributes(params[:blocks_markup])
      flash[:success] = "Markup updated"          
    end    
  end
  
end
