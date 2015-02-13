class Game < Event
  extend Enumerize
 
  belongs_to :home_team, :class_name => "Team" 
  belongs_to :away_team, :class_name => "Team"
  
  enumerize :result, in: [ :pending, :final ], default: :pending
  enumerize :completion, in: [ :regulation, :overtime, :shootout, :forfeit]

  validates_numericality_of :away_team_score, :only_integer => true
  def away_team_is_winner?
    return away_team_score > home_team_score if result
  end

  validates_numericality_of :home_team_score, :only_integer => true
  def home_team_is_winner?
    return away_team_score < home_team_score if result
  end

  #has_one :statsheet

  def has_team?(team)
    id = team.class == Team ? team.id : team
    id == away_team_id || id == home_team_id
  end

  def opponent_id(team)
    throw :team_not_present unless has_team?(team)
    id == away_team_id ? home_team_id : away_team_id
  end

  def opponent_name(team)
    throw :team_not_present unless has_team?(team)  
    id = team.class == Team ? team.id : team  
    id == away_team_id ? home_team_name : away_team_name
  end

  def opponent(team)
    throw :team_not_present unless has_team?(team) 
    id = team.class == Team ? team.id : team   
    id == away_team_id ? home_team : away_team
  end

  before_save :update_team_info
  def update_team_info
    if team = self.away_team
      self.away_team_name = team.name unless away_team_custom_name
    else
      self.away_team_name = '' unless away_team_custom_name
    end
    if team = self.home_team
      self.home_team_name = team.name unless home_team_custom_name
    else
      self.home_team_name = '' unless home_team_custom_name
    end
  end

  before_save :update_summary
  def update_summary
    if result.final?
      tag = ''
      if completion.overtime?
        tag = ' (OT)'
      elsif completion.shootout?
        tag = ' (SO)'
      elsif completion.forfeit?
        tag = ' (FORFEIT)'
      end
      if away_team_score > home_team_score
        summary = "#{away_team_name} #{away_team_score}, #{home_team_name} #{home_team_score}#{tag}"
      else
        summary = "#{home_team_name} #{home_team_score}, #{away_team_name} #{away_team_score}#{tag}"
      end
    else
      summary = "#{away_team_name} at #{home_team_name}"
    end
    summary = [text_before, summary, text_after].join(" ").strip
    self.summary = summary
  end

  def display_score?
    self.final?
  end

  def has_statsheet?
    self.statsheet
  end

  def can_add_statsheet?
    !self.has_statsheet? && self.starts_on < DateTime.now
  end
  
  scope :without_result, ->{ where(result: nil) }
  
  def apply_mongo_home_team_id! mongo_id
    self.home_team = Team.where(mongo_id: mongo_id.to_s).first    
  end
  
  def apply_mongo_away_team_id! mongo_id
    self.away_team = Team.where(mongo_id: mongo_id.to_s).first
  end
  
  def apply_mongo_result! mongo_result
    if mongo_result
      self.home_team_score = mongo_result['home_score']
      self.away_team_score = mongo_result['away_score']
      self.result = 'final'
      self.completion = mongo_result['completed_in']
    end
  end
  
end
