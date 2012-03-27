class Admin::Blocks::ContactsController < Admin::Blocks::BaseController
  
  def edit
  end
  
  def update
    if @block.update_attributes(params[:blocks_contact])
      flash[:success] = "Contact updated"          
    end    
  end
  
end
