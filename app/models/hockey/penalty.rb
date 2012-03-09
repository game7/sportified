module Hockey
  class Penalty < Hockey::Event

    SEVERITIES = %w[minor major misconduct game_misconduct]
    INFRACTIONS = %w[butt_ending checking_from_behind cross-checking delay_of_game elbowing 
                    fighting holding_the_stick hooking interference kneeing roughing slashing 
                    spearing tripping]

    field :inf
    validates :inf, presence: true
    field :dur, :type => Integer
    validates :dur, presence: true
    field :severity
    validates :severity, presence: true
    field :start_per
    field :start_min, :type => Integer
    field :start_sec, :type => Integer
    field :end_per
    field :end_min, :type => Integer
    field :end_sec, :type => Integer

    class << self
      def severities
        SEVERITIES.collect{|i| i.humanize}
      end
      def infractions
        INFRACTIONS.collect{|i| i.humanize}
      end
    end

    def start_time
      format_time(self.start_min, self.start_sec)
    end

    def end_time
      format_time(self.end_min, self.end_sec)
    end

  end
end