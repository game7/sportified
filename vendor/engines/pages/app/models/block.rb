class Block
  include Mongoid::Document
  include Mongoid::Timestamps

  field :title
  field :position, :type => Integer

  embedded_in :page

  def partial
    self.class.to_s.underscore
  end

end
