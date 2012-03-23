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
     
  end
end