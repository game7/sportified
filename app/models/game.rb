class Game
  include Mongoid::Document
  
  field :starts_on, :type => DateTime
  field :home_team_name
  field :home_team_use_custom_name, :type => Boolean
  field :away_team_name
  field :away_team_use_custom_name, :type => Boolean

  referenced_in :season, :inverse_of => :games
  referenced_in :home_team, :class_name => "Team"
  referenced_in :away_team, :class_name => "Team"

  before_save :update_home_team_name
  before_save :update_away_team_name

  private

    def update_home_team_name
      if !self.home_team_use_custom_name
        self.home_team_name = self.home_team ? self.home_team.name : ''
      end
    end

    def update_away_team_name
      if !self.away_team_use_custom_name
        self.away_team_name = self.away_team ? self.away_team.name : ''
      end      
    end

end
