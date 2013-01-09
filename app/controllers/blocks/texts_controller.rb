class Blocks::TextsController < BlocksController
  
  def edit
  end
  
  def update
    if @block.update_attributes(params[:blocks_text])
      flash[:success] = "Text updated"          
    end    
  end
  
end
