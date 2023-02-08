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

class Blocks::TextsController < BlocksController
  def edit; end

  def update
    return unless @block.update(blocks_text_params)

    flash[:success] = 'Text updated'
  end

  private

  def blocks_text_params
    params.required(:blocks_text).permit(:title, :caption, :body)
  end
end
