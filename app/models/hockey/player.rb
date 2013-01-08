module Hockey
  class Player
    include Mongoid::Document
    include Sides
    include Stats
    before_save :set_games_played

    field :played, :type => Boolean, :default => true
    field :first_name
    field :last_name
    field :num
    
    def name
      "#{first_name} #{last_name}"
    end

    belongs_to :player
    embedded_in :statsheet, :class_name => "Hockey::Statsheet"

    scope :with_num, ->(n) { where(num: n) }

    def from_player(player, side)
      self.side = side
      self.player_id = player.id
      self.first_name = player.first_name
      self.last_name = player.last_name
      self.num = player.jersey_number
    end
    
    def set_games_played
      self.gp = self.played == true ? 1 : 0
    end
    
    def to_result
      result = Hockey::Player::Result.new
      result.load(statsheet.game, self)
      result
    end

  end
end