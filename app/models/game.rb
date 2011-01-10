class Game
  include Mongoid::Document

  TEAM_ALIGNMENT = %w[home away]

  accepts_nested_attributes_for :left_team
  accepts_nested_attributes_for :right_team
 
  field :starts_on, :type => DateTime

  referenced_in :season, :inverse_of => :games

  embeds_one :left_team, :class_name => "GameTeam"
  embeds_one :right_team, :class_name => "GameTeam"

  before_save :update_team_names

  private

    # workaound to overcome mongoid not cascading events to embedded documents
    def update_team_names
      self.left_team.update_team_name if self.left_team
      self.right_team.update_team_name if self.right_team
    end

end
