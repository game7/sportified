class Team::Record
  include Mongoid::Document
  extend ActiveModel::Naming
  
  def self.model_name
    ActiveModel::Name.new(self, Team)
  end

  field :gp, :type => Integer, :default => 0
  field :w, :type => Integer, :default => 0
  field :l, :type => Integer, :default => 0
  field :t, :type => Integer, :default => 0
  field :rw, :type => Integer, :default => 0
  field :rl, :type => Integer, :default => 0
  field :fw, :type => Integer, :default => 0
  field :fl, :type => Integer, :default => 0
  field :otw, :type => Integer, :default => 0
  field :otl, :type => Integer, :default => 0
  field :sow, :type => Integer, :default => 0
  field :sol, :type => Integer, :default => 0
  field :ffw, :type => Integer, :default => 0
  field :ffl, :type => Integer, :default => 0
  field :pts, :type => Integer, :default => 0
  field :pct, :type => Float, :default => 0.00
  field :scored, :type => Integer, :default => 0
  field :allowed, :type => Integer, :default => 0
  field :margin, :type => Integer, :default => 0
  field :last
  field :run, :type => Integer, :default => 0
  field :stk
  field :owp, :type => Float, :default => 0.00
  field :oowp, :type => Float, :default => 0.00
  field :sos, :type => Float, :default => 0.00
  field :rpi, :type => Float, :default => 0.00

  embedded_in :team
  embeds_many :results, :class_name => 'TeamGameResult'

  def self.list_fields
    fields = []
    TeamRecord.fields.each do |f|
      name = f[0]
      fields << name unless ["season_id","team_id"].include?(name)
    end
    fields.sort
  end

  def reset!
    self.gp = 0
    self.w = 0
    self.l = 0
    self.t = 0
    self.rw = 0
    self.rl = 0
    self.otw = 0
    self.otl = 0
    self.sol = 0
    self.sow = 0
    self.ffl = 0
    self.ffw = 0
    self.pts = 0
    self.pct = 0.00
    self.scored = 0
    self.allowed = 0
    self.margin = 0
    self.last = nil
    self.run = 0
    self.stk = nil
    self.owp = 0.00
    self.oowp = 0.00
    self.sos = 0.00
    self.rpi = 0.00
    self.results.each{ |r| r.delete }
  end

  def post_result_from_game(game)

    raise 'Game already posted to team record' if is_game_posted?(game)

    @team_game_result = TeamGameResult.new(:team => self.team.id, :game => game)
    apply_team_game_result(@team_game_result)
    
  end

  def cancel_result_for_game(game)
    @result = self.results.where( :game_id => game.id ).first
    if @result
      @result.delete      
      remove_team_game_result(@result)
    end
  end

  def is_game_posted?(game)
    results.where(:game_id => game.id).count > 0
  end

  def apply_decision(decision, completed_in, i)
    case decision
      when 'win'
        self.w += i
        case completed_in
          when 'regulation'
            self.rw += i
          when 'overtime'
            self.otw += i
          when 'shootout'
            self.sow += i
          when 'forfeit'
            self.ffw += i
        end
      when 'loss'
        self.l += i
        case completed_in
          when 'regulation'
            self.rl += i
          when 'overtime'
            self.otl += i
          when 'shootout'
            self.sol += i
          when 'forfeit'
            self.ffl += i
        end
      when 'tie'
        self.t += i
    end
  end

  def apply_team_game_result(result)
    
    self.gp += 1
    self.apply_decision(result.decision, result.completed_in, 1)
    self.update_points!
    self.update_win_percentage!
    
    self.scored += result.scored
    self.allowed += result.allowed
    self.update_margin!

    self.results << result 

    self.update_streak!  
  end

  def remove_team_game_result(result)
    self.gp -= 1
    self.apply_decision(result.decision, result.completed_in, -1)
    self.update_points!
    self.update_win_percentage!
    
    self.scored -= result.scored
    self.allowed -= result.allowed
    self.update_margin!  
    self.update_streak!  
  end

  def update_margin!
    self.margin = self.scored - self.allowed
  end

  def update_points!
    self.pts = (2 * self.w) + (1 * self.t) + (1 * self.otl) + (1 * self.sol)
  end

  def update_win_percentage!
    self.pct = self.gp > 0 ? self.w.fdiv(self.gp) : 0.00
  end

  def update_streak!
    self.stk = nil
    self.run = 0
    results.desc(:played_on).each_with_index do |result, index|
      self.last = result.decision if index == 0
      break unless self.last == result.decision 
      self.run += 1
    end
    case self.last
      when 'win'
        self.stk = 'Won ' + self.run.to_s
      when 'loss'
        self.stk = 'Lost ' + self.run.to_s
      when 'tie'
        self.stk = 'Tied ' + self.run.to_s
    end
  end

end
