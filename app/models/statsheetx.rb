class Statsheetx
  include Mongoid::Document

  before_create :load_game_info

  belongs_to :game, :class_name => "Game", index: true
  validates_presence_of :game

  def load_game_info

  end


end
