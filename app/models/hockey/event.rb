class Hockey::Event < ActiveRecord::Base
  belongs_to :statsheet

  PER = %w[1 2 3 OT]

  scope :goals, ->{ where(:"_type" => 'Hockey::Goal') }
  scope :penalties, ->{ where(:"_type" => 'Hockey::Penalty') }
  scope :sorted_by_time, ->{ order_by(:per.asc, :min.desc, :sec.desc) }
  scope :for_period, ->(period) { where(per: period) }

  validates_presence_of :per, :min, :sec
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
