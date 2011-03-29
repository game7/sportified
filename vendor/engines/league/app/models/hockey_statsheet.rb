class HockeyStatsheet < Statsheet
  
  field :left_team_name
  field :right_team_name
  field :left_score, :type => Integer, :default => 0
  field :right_score, :type => Integer, :default => 0

  field :latest_per
  field :latest_min, :type => Integer
  field :latest_sec, :type => Integer

  field :min_1, :type => Integer
  field :min_2, :type => Integer
  field :min_3, :type => Integer
  field :min_ot, :type => Integer

  embeds_many :players, :class_name => "HockeyPlayer"
  embeds_many :events, :class_name => "HockeyEvent", :before_add => :event_created
  embeds_many :goaltenders, :class_name => "HockeyGoaltender"

  before_save :capture_latest_event
  before_save :update_team_scores

  def load_game_info
    super
    if self.game
      set_team_names(self.game)
      load_players(self.game.left_team, "L")
      load_players(self.game.right_team, "R")
    end
  end

  def set_team_names(game)
    self.left_team_name = game.left_team_name
    self.right_team_name = game.right_team_name    
  end

  def load_players(team, side)
    team.players.each{|p| players.build.from_player(p, side)} if team
  end

  def capture_latest_event
    events.each{|e| set_latest_event_time(e) if e.new_record? && is_latest?(e) }
  end

  def update_team_scores
    self.left_score = 0
    self.right_score = 0
    events.goals.each do |g|
      self.left_score += 1 if g.side == 'L'
      self.right_score += 1 if g.side == 'R'
    end
  end

  def is_latest?(event)
    latest_per.blank? || (latest_per.to_s < event.per && latest_min > event.min && latest_sec > event.sec)
  end

  def set_latest_event_time(event)
    self.latest_per = event.per
    self.latest_min = event.min
    self.latest_sec = event.sec    
  end


end
