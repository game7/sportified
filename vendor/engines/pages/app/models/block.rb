class Block
  include Mongoid::Document
  include Mongoid::Timestamps

  field :title
  field :position, :type => Integer

  embedded_in :page

  def name
    self.class.to_s.titlecase
  end

  def at_top?
    self == page.blocks.first
  end

  def at_bottom?
    self == page.blocks.last
  end

  def move_to_top
    page.move_block_to_top(self)
  end

  def move_to_bottom
    page.move_block_to_bottom(self)
  end

  def move_up
    page.move_block_up(self)
  end

  def move_down
    page.move_block_down(self)
  end

end
