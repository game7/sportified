class HockeyPenalty < HockeyEvent

  SEVERITY = %w[MNR MJR MSC GMSC]

  field :inf
  field :dur
  field :severity
  field :start_per
  field :start_min, :type => Integer
  field :start_sec, :type => Integer
  field :end_per
  field :end_min, :type => Integer
  field :end_sec, :type => Integer

  class << self
    def severities
      SEVERITY
    end
  end

  def start_time
    format_time(self.start_min, self.start_sec)
  end

  def end_time
    format_time(self.end_min, self.end_sec)
  end

end
