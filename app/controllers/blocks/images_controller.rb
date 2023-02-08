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
#  created_at :datetime
#  updated_at :datetime
#  file       :string
#

class Blocks::ImagesController < BlocksController
  def dialog; end

  def edit; end

  def update
    return unless @block.update(blocks_image_params)

    flash[:success] = 'Image updated'
  end

  private

  def blocks_image_params
    params.required(:blocks_image).permit(:link_url, :alignment, :height, :width, :file, :remote_file_url, :file_cache)
  end
end
