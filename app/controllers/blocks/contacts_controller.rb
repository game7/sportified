# == Schema Information
#
# Table name: blocks
#
#  id         :integer          not null, primary key
#  page_id    :integer
#  type       :string(255)
#  section_id :integer
#  column     :integer
#  position   :integer
#  options    :hstore
#  mongo_id   :string(255)
#  created_at :datetime
#  updated_at :datetime
#  file       :string(255)
#

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
