class Game
  include Mongoid::Document

  TEAM_ALIGNMENT = %w[home away]
 
  field :starts_on, :type => DateTime
  field :left_team_name
  field :right_team_name

  referenced_in :division
  referenced_in :season
  referenced_in :left_team, :class_name => "Team"
  referenced_in :right_team, :class_name => "Team"
  embeds_one :result, :class_name => "GameResult"

  scope :in_the_past, :where => { :starts_on.lt => DateTime.now }
  scope :from, lambda { |from| { :where => { :starts_on.gt => from } } }
  scope :to, lambda { |to| { :where => { :starts_on.lt => to } } }
  scope :between, lambda { |from, to| { :where => { :starts_on.gt => from, :starts_on.lt => to } } }

  class << self
    def for_team(t)
      id = t.class == Team ? t.id : t
      any_of( { "left_team_id" => id }, { "right_team_id" => id } )
    end
    def for_season(s)
      id = s.class == Season ? s.id : s
      where(:season_id => id)
    end
    def for_division(d)
      id = d.class == Division ? d.id : d
      where(:division_id => id)
    end
  end

  before_save :update_team_names
  
  def has_result?
    !self.result.nil?
  end

  def can_add_result?
    !self.has_result? && self.starts_on < DateTime.now
  end

  def can_delete_result?
    self.has_result?
  end

  private

    def update_team_names
      self.left_team_name = self.left_team.name if self.left_team
      self.right_team_name = self.right_team.name if self.right_team
    end

end
