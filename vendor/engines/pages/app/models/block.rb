class Block
  include Mongoid::Document
  include Mongoid::Timestamps

  field :title
  field :position, :type => Integer

  embedded_in :page

  def name
    self.class.to_s.titlecase
  end

  def partial
    self.class.to_s.underscore
  end

  def edit_partial
    "edit_" + self.class.to_s.underscore    
  end

end
