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

class Blocks::FeedsController < BlocksController
  
  def edit

  end
  
  def update
    if @block.update_attributes(blocks_feed_params)
      flash[:success] = "Feed updated"          
    end    
  end
  
  private
  
  def blocks_feed_params
    params.required(:blocks_feed).permit(:post_count, :tags)
  end  
  
end
