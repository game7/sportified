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

class Blocks::EventFeedsController < BlocksController

  def edit

  end

  def update
    if @block.update_attributes(blocks_event_feed_params)
      flash[:success] = 'Event Feed updated'
    end
  end

  private

  def blocks_event_feed_params
    params.required(:blocks_event_feed).permit(:title, :event_count, tags: [])
  end

end
