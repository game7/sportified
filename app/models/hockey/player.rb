module Hockey
  class Player
    include Mongoid::Document
    include Sides

    field :played, :type => Boolean, :default => true
    field :first_name
    field :last_name
    field :num
    field :g, :type => Integer, :default => 0
    field :a, :type => Integer, :default => 0
    field :pts, :type => Integer, :default => 0
    field :pen, :type => Integer, :default => 0
    field :pim, :type => Integer, :default => 0
    
    def name
      "#{first_name} #{last_name}"
    end

    belongs_to :player
    embedded_in :hockey_statsheet

    scope :with_num, lambda { |n| { :where => { :num => n } } }

    def from_player(player, side)
      self.side = side
      self.player_id = player.id
      self.first_name = player.first_name
      self.last_name = player.last_name
      self.num = player.jersey_number
    end

  end
end