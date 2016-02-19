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

class Blocks::DocumentsController < BlocksController
  
  def dialog
  end
  
  def edit
  end
  
  def update
    if @block.update_attributes(blocks_document_params)
      flash[:success] = "Document updated"
    end
  end
  
  private
  
  def blocks_document_params
    params.required(:blocks_document).permit(:title, :description, :file, :file_cache)
  end
  
end
