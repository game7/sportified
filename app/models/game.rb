
class Game < Event

  belongs_to :away_team, :class_name => "Team"
  field :away_custom_name, :type => Boolean
  field :away_team_name
  field :away_team_score, :type => Integer, :default => 0
  validates_numericality_of :away_team_score, :only_integer => true
  def away_team_is_winner?
    return result.away_score > result.home_score if result
  end

  belongs_to :home_team, :class_name => "Team"
  field :home_team_name
  field :home_custom_name, :type => Boolean
  field :home_team_score, :type => Integer, :default => 0
  validates_numericality_of :home_team_score, :only_integer => true
  def home_team_is_winner?
    return result.away_score < result.home_score if result
  end

  embeds_one :result, class_name: "Game::Result", cascade_callbacks: true
  has_one :statsheet

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
    self.team_ids = []
    self.division_ids ||= []
    if team = self.away_team
      self.away_team_name = team.name unless away_custom_name
      team_ids << team.id
      division_ids << team.division_id unless division_ids.include?(team.division_id)
    else
      self.away_team_name = '' unless away_custom_name
    end
    if team = self.home_team
      self.home_team_name = team.name unless home_custom_name
      team_ids << team.id
      division_ids << team.division_id unless division_ids.include?(team.division_id)
    else
      self.home_team_name = '' unless home_custom_name
    end
  end

  before_save :update_summary
  def update_summary
    if has_result?
      tag = ''
      case result.completed_in
        when 'overtime' 
          tag = ' (OT)'
        when 'shootout' 
          tag = ' (SO)'
        when 'forfeit' 
          tag = ' (FORFEIT)'
      end
      if result.away_score > result.home_score
        summary = "#{away_team_name} #{result.away_score}, #{home_team_name} #{result.home_score}#{tag}"
      else
        summary = "#{home_team_name} #{result.home_score}, #{away_team_name} #{result.away_score}#{tag}"
      end
    else
      summary = "#{away_team_name} vs. #{home_team_name}"
    end
    self.summary = summary
  end

  def has_result?
    !self.result.nil?
  end

  def display_score?
    self.active? || self.completed? || self.final?
  end

  def has_statsheet?
    self.statsheet
  end

  def can_add_statsheet?
    !self.has_statsheet? && self.starts_on < DateTime.now
  end
  
  scope :without_result, where(result: nil)

end
