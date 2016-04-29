# == Schema Information
#
# Table name: blocks
#
#  id         :integer          not null, primary key
#  page_id    :integer
#  type       :string
#  section_id :integer
#  column     :integer
#  position   :integer
#  options    :hstore
#  mongo_id   :string
#  created_at :datetime
#  updated_at :datetime
#  file       :string
#

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
