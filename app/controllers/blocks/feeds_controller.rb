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

class Blocks::FeedsController < BlocksController
  def edit; end

  def update
    return unless @block.update(blocks_feed_params)

    flash[:success] = 'Feed updated'
  end

  private

  def blocks_feed_params
    params.required(:blocks_feed).permit(:title, :post_count, :divider, tags: [])
  end
end
