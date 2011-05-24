class GameResult
  include ActiveModel::Conversion
  extend ActiveModel::Naming
  extend Forwardable

  attr_accessor :transition_to

  def_delegators :game, 
    :id, :state,
    :left_team_name, :right_team_name,
    :left_team_score, :left_team_score=,
    :right_team_score, :right_team_score=,
    :completed_in, :completed_in=,
    :errors, :valid?, :save, :persisted?,
    :available_transitions

  def initialize(game)
    @game = game
  end

  def game
    @game
  end

  def update_attributes(params)
    params.each_pair do |attribute, value|
      self.send :"#{attribute}=", value
    end unless params.nil?
    if params[:transition_to].present?
      game.send "#{params[:transition_to]}!"
    else
      self.save
    end
  end

  def self.find(param)
    new(Game.find(param))
  end

end
