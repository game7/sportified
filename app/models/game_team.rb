class GameTeam
  include Mongoid::Document

  OUTCOMES = %w[win loss tie]

  accepts_nested_attributes_for :sub_scores

  field :name
  field :use_custom_name, :type => Boolean
  field :score, :type => Integer
  field :alignment
  field :outcome

  referenced_in :team
  embedded_in :game, :inverse_of => :left_team
  embedded_in :game, :inverse_of => :right_team

  #before_save :update_team_name

  def update_team_name
    if !self.use_custom_name
      team = self.team
      self.name = team ? team.name : ''
    end
  end

end
