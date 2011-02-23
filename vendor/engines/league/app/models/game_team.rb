class GameTeam
  include Mongoid::Document

  OUTCOMES = %w[win loss tie]

  field :name
  field :use_custom_name, :type => Boolean
  field :score, :type => Integer
  field :alignment
  field :outcome

  referenced_in :team
  embedded_in :game

  #before_save :update_team_name

  def update_team_name
    if !self.use_custom_name
      t = self.team
      self.name = t ? t.name : ''
    end
  end

end
