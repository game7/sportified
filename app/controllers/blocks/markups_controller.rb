class Blocks::MarkupsController < BlocksController
  
  def edit
  end
  
  def update
    if @block.update_attributes(blocks_markup_params)
      flash[:success] = "Markup updated"          
    end    
  end
  
  private
  
  def blocks_markup_params
    params.required(:blocks_markup).permit(:body)
  end  
  
end
