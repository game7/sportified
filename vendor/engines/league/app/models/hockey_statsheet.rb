class HockeyStatsheet < Statsheet
  
  field :left_team_name
  field :right_team_name
  field :left_score, :type => Integer, :default => 0
  field :right_score, :type => Integer, :default => 0

  field :latest_per
  field :latest_min, :type => Integer
  field :latest_sec, :type => Integer

  field :min_1, :type => Integer, :default => 0
  field :min_2, :type => Integer, :default => 0
  field :min_3, :type => Integer, :default => 0
  field :min_ot, :type => Integer, :default => 0
  def min_total
    min_1 + min_2 + min_3 + min_ot
  end

  # goal summary
  # ---------------------------------------------------

  field :left_goals_1, :type => Integer, :default => 0
  field :left_goals_2, :type => Integer, :default => 0
  field :left_goals_3, :type => Integer, :default => 0
  field :left_goals_ot, :type => Integer, :default => 0
  field :right_goals_1, :type => Integer, :default => 0
  field :right_goals_2, :type => Integer, :default => 0
  field :right_goals_3, :type => Integer, :default => 0
  field :right_goals_ot, :type => Integer, :default => 0

  def left_goals_total
    left_goals_1 + left_goals_2 + left_goals_3 + left_goals_ot 
  end
  def right_goals_total
    right_goals_1 + right_goals_2 + right_goals_3 + right_goals_ot    
  end

  def clear_goals
    ['left', 'right'].each do |side|
      ['1','2','3','ot'].each do |per|
        self["#{side}_goals_#{per}"] = 0
      end
    end
  end

  def calculate_goals
    clear_goals
    events.goals.each do |g|
      att = g.side.upcase == 'L' ? "left_goals_#{g.per.downcase}" : "right_goals_#{g.per.downcase}"
      self[att] += 1
    end
  end

  # shots summary
  # ---------------------------------------------------

  field :left_shots_1, :type => Integer, :default => 0
  field :left_shots_2, :type => Integer, :default => 0
  field :left_shots_3, :type => Integer, :default => 0
  field :left_shots_ot, :type => Integer, :default => 0
  field :right_shots_1, :type => Integer, :default => 0
  field :right_shots_2, :type => Integer, :default => 0
  field :right_shots_3, :type => Integer, :default => 0
  field :right_shots_ot, :type => Integer, :default => 0

  def left_shots_total
    left_shots_1 + left_shots_2 + left_shots_3 + left_shots_ot 
  end
  def right_shots_total
    right_shots_1 + right_shots_2 + right_shots_3 + right_shots_ot    
  end

  def clear_shots
    ['left', 'right'].each do |side|
      ['1','2','3','ot'].each do |per|
        self["#{side}_shots_#{per}"] = 0
      end
    end
  end  

  def left_pim_total
    events.penalties.left.sum(:dur)
  end
  def right_pim_total
    events.penalties.left.sum(:dur)    
  end

  def overtime?
    min_ot > 0
  end

  def shootout?
    false
  end

  embeds_many :players, :class_name => "HockeyPlayer" do
    def build(attributes = {}, type = nil, &block)
      super
    end
    def <<(*args)
      super
    end
    def delete(document)
      super
    end    
  end

  embeds_many :events, :class_name => "HockeyEvent" do
    def build(attributes = {}, type = nil, &block)
      super
    end
    def <<(*args)
      super
    end
    def delete(document)
      super
    end
  end

  embeds_many :goaltenders, :class_name => "HockeyGoaltender" do
    def build(attributes = {}, type = nil, &block)
      super
    end
    def <<(*args)
      super
    end
    def delete(document)
      super
    end
  end    

  before_save :capture_latest_event
  before_save :update_team_scores

  def load_game_info
    super
    if self.game
      set_team_names(self.game)
      load_players(self.game)
    end
  end

  def set_team_names(game)
    self.left_team_name = game.left_team_name
    self.right_team_name = game.right_team_name    
  end

  def load_players(game)
    load_team_players(game.left_team, "L")
    load_team_players(game.right_team, "R")    
  end

  def load_team_players(team, side)
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
    latest_per.blank? || (latest_per.to_s < event.per.to_s && latest_min > event.min && latest_sec > event.sec)
  end

  def set_latest_event_time(event)
    self.latest_per = event.per
    self.latest_min = event.min
    self.latest_sec = event.sec    
  end

  def reload_players
    self.players = []
    load_players(self.game)
  end


end
