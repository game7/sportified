class HockeyEvent
  include Mongoid::Document

  SIDE = %w[L R]
  PER = %w[1 2 3 OT]

  field :side
  field :per
  field :min, :type => Integer
  field :sec, :type => Integer
  field :plr

  embedded_in :parent, :inverse_of => :events, :class_name => 'HockeyStatsheet'

  scope :left, :where => { :side => 'L' }
  scope :right, :where => { :side => 'R' }
  scope :goals, :where => { :_type => 'HockeyGoal' }
  scope :penalties, :where => { :_type => 'HockeyPenalty' }
  scope :sorted_by_time, order_by(:per.asc, :min.desc, :sec.desc)
  scope :for_period, lambda { |period| { :where => { :per => period } } }

  validates_presence_of :side, :per, :min, :sec, :plr
  validates_numericality_of :min, :sec

  def time
    format_time(self.min, self.sec)
  end
  
  class << self
    def periods
      PER
    end
  end

  protected

    def format_time(min, sec)
      min.to_s + ':' + "0#{sec.to_s}"[-2,2] unless min.blank? || sec.blank?
    end

end
