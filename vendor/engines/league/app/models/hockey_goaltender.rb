class HockeyGoaltender
  include Mongoid::Document

  SIDE = %w[L R]

  field :side
  field :plr

  field :min_1, :type => Integer, :default => 0
  field :min_2, :type => Integer, :default => 0
  field :min_3, :type => Integer, :default => 0
  field :min_ot, :type => Integer, :default => 0

  field :shots_1, :type => Integer, :default => 0
  field :shots_2, :type => Integer, :default => 0
  field :shots_3, :type => Integer, :default => 0
  field :shots_ot, :type => Integer, :default => 0

  field :goals_1, :type => Integer, :default => 0
  field :goals_2, :type => Integer, :default => 0
  field :goals_3, :type => Integer, :default => 0
  field :goals_ot, :type => Integer, :default => 0

  embedded_in :hockey_scoresheet

  validates_presence_of :side, :plr
  validates_numericality_of :min_1, :min_2

  scope :left, :where => { :side => 'L' }
  scope :right, :where => { :side => 'R' }

  def min_total
    min_1 + min_2 + min_3 + min_ot
  end

  def shots_total
    shots_1 + shots_2 + shots_3 + shots_ot
  end

  def goals_total
    goals_1 + goals_2 + goals_3 + goals_ot
  end

end
