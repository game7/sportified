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
      att = "#{g.side}_goals_#{g.per.downcase}"
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
      event = super
      base.event_created(event)
      event
    end
    def <<(*args)
      events = super
      args.each{ |event| base.event_created(event) }
      events
    end
    def delete(document)
      super
      base.event_deleted(document)
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

  before_save :update_team_scores
  def update_team_scores
    self.left_score = 0
    self.right_score = 0
    events.goals.each do |g|
      self.left_score += 1 if g.side == 'left'
      self.right_score += 1 if g.side == 'right'
    end
  end

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
    load_team_players(game.left_team, "left")
    load_team_players(game.right_team, "right")    
  end

  def load_team_players(team, side)
    team.players.each{|p| players.build.from_player(p, side)} if team
  end



  def is_latest?(event)
    if latest_per.blank? || latest_per.to_s < event.per.to_s 
      result = true
    elsif latest_per.to_s == event.per.to_s
      if latest_min > event.min 
        result = true
      elsif latest_min == event.min
        if latest_sec > event.sec
          result = true
        end
      end
    end
    result ||= false
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

  def event_created(event)
    
    set_latest_event_time(event) if is_latest?(event)    
    
    case event.class.to_s
      when 'HockeyGoal'
        goal_created(event)
      when 'HockeyPenalty'
        penalty_created(event)
    end

  end

  def event_deleted(event)
    
    latest = events.sorted_by_time.last
    set_latest_event_time(latest) if latest
    
    case event.class.to_s
      when 'HockeyGoal'
        goal_deleted(event)
      when 'HockeyPenalty'
        penalty_deleted(event)
    end

  end

  def goal_created(goal)
    increment_goals_for_player(goal.side, goal.plr, 1)
    increment_assists_for_player(goal.side, goal.a1, 1)
    increment_assists_for_player(goal.side, goal.a2, 1)
  end

  def goal_deleted(goal)
    increment_goals_for_player(goal.side, goal.plr, -1)
    increment_assists_for_player(goal.side, goal.a1, -1)
    increment_assists_for_player(goal.side, goal.a2, -1)
  end

  def penalty_created(pen)
    increment_penalties_for_player(pen.side, pen.plr, 1, pen.dur)
  end

  def penalty_deleted(pen)
    increment_penalties_for_player(pen.side, pen.plr, -1, -pen.dur)
  end

  def increment_goals_for_player(side, num, i)
    plr = players.for_side(side).with_num(num).first
    plr.g += i    if plr
    plr.pts += i  if plr
  end

  def increment_assists_for_player(side, num, i)
    plr = players.for_side(side).with_num(num).first
    plr.a += i    if plr
    plr.pts += i  if plr
  end

  def increment_penalties_for_player(side, num, i, min)
    plr = players.for_side(side).with_num(num).first
    plr.pen += i    if plr
    plr.pim += min  if plr
  end

  def calculate_player_stats
    clear_player_stats
    events.goals.each{|goal| goal_created(goal)}
    events.penalties.each{|pen| penalty_created(pen)}
  end

  def clear_player_stats
    players.each do |plr|
      ['g','a','pts','pen','pim'].each do |att| 
        plr[att] = 0
      end
    end
  end

  def score_by_minute
    
    result = []
    self.min_1.downto(0) do |i|
      result << { :period => '1', :minute => i, :left => 0, :right => 0 }
    end if self.min_1 > 0
    self.min_2.downto(0) do |i|
      result << { :period => '2', :minute => i, :left => 0, :right => 0 }
    end if self.min_2 > 0
    self.min_3.downto(0) do |i|
      result << { :period => '3', :minute => i, :left => 0, :right => 0 }
    end if self.min_3 > 0
    self.min_ot.downto(0) do |i|
      result << { :period => 'ot', :minute => i, :left => 0, :right => 0 }
    end if self.min_ot > 0

    goals = self.events.goals.sorted_by_time.entries
    
    next_goal = goals.shift
    left = 0
    right = 0
    result.each do |minute|
      while next_goal.present?
        if next_goal.min == minute[:minute]
          if next_goal.side == 'left'
            left += 1
          else
            right += 1
          end
          next_goal = goals.shift
        else
          break
        end
      end
      minute[:left] = left
      minute[:right] = right
    end

    result
  end

end
