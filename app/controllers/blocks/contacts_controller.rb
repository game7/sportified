class Blocks::ContactsController < BlocksController
  
  def update
    if @block.update_attributes(blocks_params)
      flash[:success] = "Contact updated"          
    end
  end
  
  private
  
  def blocks_params
    params.required(:blocks_contact).permit(:first, :last, :title, :phone, :email, :show_email)
  end
  
end
