class HockeyPlayer
  include Mongoid::Document
  include League::Sides

  field :played, :type => Boolean, :default => true
  field :name
  field :num
  field :g, :type => Integer, :default => 0
  field :a, :type => Integer, :default => 0
  field :pts, :type => Integer, :default => 0
  field :pen, :type => Integer, :default => 0
  field :pim, :type => Integer, :default => 0

  referenced_in :player
  embedded_in :hockey_statsheet

  scope :with_num, lambda { |n| { :where => { :num => n } } }

  def from_player(player, side)
    self.side = side
    self.player_id = player.id
    self.name = player.full_name
    self.num = player.jersey_number
  end

end
