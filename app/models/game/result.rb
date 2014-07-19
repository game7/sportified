class Game::Result
  include Mongoid::Document
  extend ActiveModel::Naming
  
  def self.model_name
    ActiveModel::Name.new(self, Team)
  end
  
  embedded_in :game
  
  field :home_score, type: Integer, default: 0
  validates :home_score, presence: true
  
  field :away_score, type: Integer, default: 0
  validates :away_score, presence: true
  
  COMPLETED_IN = %w[regulation overtime shootout forfeit]
  def self.completed_in_options
    COMPLETED_IN.collect{|o| [o.humanize, o] }
  end  
  
  field :completed_in
  validates :completed_in, presence: true
  
  field :exclude_from_team_records, type: Boolean
  
  after_create do |result|
    game = result.game
    Team::Record::Processor.post_game!(game)
    #processor.update_power_rankings_from_game(game)    
  end  

end
