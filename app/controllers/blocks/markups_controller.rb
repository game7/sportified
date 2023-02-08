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

class Blocks::MarkupsController < BlocksController
  def edit; end

  def update
    return unless @block.update(blocks_markup_params)

    flash[:success] = 'Markup updated'
  end

  private

  def blocks_markup_params
    params.required(:blocks_markup).permit(:title, :body)
  end
end
