class Game
  include Mongoid::Document

  TEAM_ALIGNMENT = %w[home away]

  accepts_nested_attributes_for :left_team
  accepts_nested_attributes_for :right_team
 
  field :starts_on, :type => DateTime

  referenced_in :division, :inverse_of => :gemes
  referenced_in :season, :inverse_of => :games

  embeds_one :left_team, :class_name => "GameTeam"
  embeds_one :right_team, :class_name => "GameTeam"
  embeds_one :result, :class_name => "GameResult"

  scope :in_the_past, :where => { :starts_on.lt => DateTime.now }
  scope :from, lambda { |from| { :where => { :starts_on.gt => from } } }
  scope :to, lambda { |to| { :where => { :starts_on.lt => to } } }
  scope :between, lambda { |from, to| { :where => { :starts_on.gt => from, :starts_on.lt => to } } }

  before_save :update_team_names
  
  before_save :update_division
  def update_division
    self.division_id = self.season.division_id
  end

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

    # workaound to overcome mongoid not cascading events to embedded documents
    def update_team_names
      self.left_team.update_team_name if self.left_team
      self.right_team.update_team_name if self.right_team
    end

end
