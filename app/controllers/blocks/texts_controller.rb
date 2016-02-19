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
