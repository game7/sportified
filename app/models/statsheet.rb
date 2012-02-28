class Statsheet
  include Mongoid::Document

  before_create :load_game_info

  references_one :game
  validates_presence_of :game

  def load_game_info

  end


end
