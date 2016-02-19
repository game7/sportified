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

class Blocks::ImagesController < BlocksController
  
  def dialog
  end
  
  def edit
  end
  
  def update  
    if @block.update_attributes(blocks_image_params)
      flash[:success] = "Image updated"
    end    
  end
  
  private
  
  def blocks_image_params
    params.required(:blocks_image).permit(:link_url, :alignment, :height, :width, :image, :remote_image_url, :image_cache)
  end
  
end
