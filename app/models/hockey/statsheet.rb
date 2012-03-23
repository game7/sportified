module Hockey
  class Statsheet < ::Statsheet
    
    field :is_posted, :type => Boolean, :default => false
    def posted?
      is_posted
    end

    field :away_team_name
    field :home_team_name
    field :away_score, :type => Integer, :default => 0
    field :home_score, :type => Integer, :default => 0

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

    field :away_goals_1, :type => Integer, :default => 0
    field :away_goals_2, :type => Integer, :default => 0
    field :away_goals_3, :type => Integer, :default => 0
    field :away_goals_ot, :type => Integer, :default => 0
    field :home_goals_1, :type => Integer, :default => 0
    field :home_goals_2, :type => Integer, :default => 0
    field :home_goals_3, :type => Integer, :default => 0
    field :home_goals_ot, :type => Integer, :default => 0

    def away_goals_total
      away_goals_1 + away_goals_2 + away_goals_3 + away_goals_ot 
    end
    def home_goals_total
      home_goals_1 + home_goals_2 + home_goals_3 + home_goals_ot    
    end

    def clear_goals
      ['away', 'home'].each do |side|
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

    field :away_shots_1, :type => Integer, :default => 0
    field :away_shots_2, :type => Integer, :default => 0
    field :away_shots_3, :type => Integer, :default => 0
    field :away_shots_ot, :type => Integer, :default => 0
    field :home_shots_1, :type => Integer, :default => 0
    field :home_shots_2, :type => Integer, :default => 0
    field :home_shots_3, :type => Integer, :default => 0
    field :home_shots_ot, :type => Integer, :default => 0

    def away_shots_total
      away_shots_1 + away_shots_2 + away_shots_3 + away_shots_ot 
    end
    def home_shots_total
      home_shots_1 + home_shots_2 + home_shots_3 + home_shots_ot    
    end

    def clear_shots
      ['away', 'home'].each do |side|
        ['1','2','3','ot'].each do |per|
          self["#{side}_shots_#{per}"] = 0
        end
      end
    end  

    def away_pim_total
      events.penalties.away.sum(:dur) || 0
    end
    def home_pim_total
      events.penalties.home.sum(:dur) || 0
    end

    def overtime?
      min_ot > 0
    end

    def shootout?
      false
    end

    embeds_many :players, :class_name => "Hockey::Player" do
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

    embeds_many :events, :class_name => "Hockey::Event" do
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

    embeds_many :goaltenders, :class_name => "Hockey::Goaltender" do
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
      self.away_score = 0
      self.home_score = 0
      events.goals.each do |g|
        self.away_score += 1 if g.side == 'away'
        self.home_score += 1 if g.side == 'home'
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
      self.away_team_name = game.away_team_name
      self.home_team_name = game.home_team_name    
    end

    def load_players(game = self.game)
      load_team_players(game.away_team, "away")
      load_team_players(game.home_team, "home")    
    end

    def load_team_players(team, side)
      player_ids = self.players.entries.collect{ |plr| plr.player_id }
      team.players.each do |team_player|
        players.build.from_player(team_player, side) unless player_ids.index(team_player.id)
      end if team
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
    
    def autoload_goaltenders
      home = goaltenders.build(:side => 'home')
      away = goaltenders.build(:side => 'away')
      
      %w{home away}.each do |side|
        %w{1 2 3 ot}.each do |per|
          eval("#{side}.min_#{per} = self.min_#{per}")
          %w{shots goals}.each do |stat|
            eval("#{side}.#{stat}_#{per} = self.#{side == "home" ? "away" : "home"}_#{stat}_#{per}")
          end
        end
      end
    end

    def event_created(event)

      set_latest_event_time(event) if is_latest?(event)    

      case event.class.to_s
        when 'Hockey::Goal'
          goal_created(event)
        when 'Hockey::Penalty'
          penalty_created(event)
      end

    end

    def event_deleted(event)

      latest = events.sorted_by_time.last
      set_latest_event_time(latest) if latest

      case event.class.to_s
        when 'Hockey::Goal'
          goal_deleted(event)
        when 'Hockey::Penalty'
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
      if num != '' && plr = players.for_side(side).with_num(num).first
        plr.g += i
        plr.pts += i
      end
    end

    def increment_assists_for_player(side, num, i)
      if num != '' && plr = players.for_side(side).with_num(num).first
        plr.a += i
        plr.pts += i 
      end
    end

    def increment_penalties_for_player(side, num, i, min)
      if num != '' && plr = players.for_side(side).with_num(num).first
        plr.pen += i
        plr.pim += min
      end
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
        result << { :period => '1', :minute => i, :away => 0, :home => 0 }
      end if self.min_1 > 0
      self.min_2.downto(0) do |i|
        result << { :period => '2', :minute => i, :away => 0, :home => 0 }
      end if self.min_2 > 0
      self.min_3.downto(0) do |i|
        result << { :period => '3', :minute => i, :away => 0, :home => 0 }
      end if self.min_3 > 0
      self.min_ot.downto(0) do |i|
        result << { :period => 'ot', :minute => i, :away => 0, :home => 0 }
      end if self.min_ot > 0

      goals = self.events.goals.sorted_by_time.entries

      next_goal = goals.shift
      away = 0
      home = 0
      result.each do |minute|
        while next_goal.present?
          if next_goal.min == minute[:minute]
            if next_goal.side == 'away'
              away += 1
            else
              home += 1
            end
            next_goal = goals.shift
          else
            break
          end
        end
        minute[:away] = away
        minute[:home] = home
      end

      result
    end

  end

end