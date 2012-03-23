module Hockey
  module Stats
    extend ActiveSupport::Concern

    included do
      field :gp, :type => Integer, :default => 0
      field :g, :type => Integer, :default => 0
      field :a, :type => Integer, :default => 0
      field :pts, :type => Integer, :default => 0
      field :pen, :type => Integer, :default => 0
      field :pim, :type => Integer, :default => 0
    end
    
    def add_stats stats
      self.gp += stats.gp
      self.g += stats.gp
      self.a += stats.a
      self.pts += stats.pts
      self.pen += stats.pen
      self.pim += stats.pim
    end
    
    def subtract_stats stats
      self.gp -= stats.gp
      self.g -= stats.gp
      self.a -= stats.a
      self.pts -= stats.pts
      self.pen -= stats.pen
      self.pim -= stats.pim
    end
    
  end
end