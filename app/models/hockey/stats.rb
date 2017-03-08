module Hockey
  module Stats
    extend ActiveSupport::Concern
    include StatsViews

    module ClassMethods

      def tokens(view)
        case view
        when "scoring"
          Hockey::Stats::SCORING
        when "penalties"
          Hockey::Stats::PENALTIES
        when "goaltending"
          Hockey::Stats::GOALTENDING
        end
      end

      def default_token(view)
        case view
        when "scoring"
          "points"
        when "penalties"
          "penalties"
        when "goaltending"
          "goals_against_average"
        end
      end

      def column(token)
        I18n.t("hockey.statistics.tokens.#{token}.col")
      end

    end

  end
end
