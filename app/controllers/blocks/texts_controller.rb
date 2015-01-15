class Blocks::TextsController < BlocksController
  
  def edit
  end
  
  def update
    if @block.update_attributes(blocks_text_params)
      flash[:success] = "Text updated"          
    end    
  end
  
  private
  
  def blocks_text_params
    params.required(:blocks_text).permit(:title, :caption, :body)
  end
  
end
