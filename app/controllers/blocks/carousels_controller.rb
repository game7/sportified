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

class Blocks::CarouselsController < BlocksController
  def edit; end

  def update
    return unless @block.update(blocks_carousel_params)

    flash[:success] = 'Carousel updated'
  end

  private

  def blocks_carousel_params
    params.required(:blocks_carousel).permit(:post_count, :shuffle, :interval, tags: [])
  end
end
