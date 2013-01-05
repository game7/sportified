class Blocks::ContactsController < BlocksController
  
  def update
    if @block.update_attributes(params[:blocks_contact])
      flash[:success] = "Contact updated"          
    end    
  end
  
end
