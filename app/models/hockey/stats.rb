module Hockey
  module Stats
    extend ActiveSupport::Concern
    include StatsViews

    included do
      field :gp, :type => Integer, :default => 0
      field :g, :type => Integer, :default => 0
      field :a, :type => Integer, :default => 0
      field :pts, :type => Integer, :default => 0
      field :pen, :type => Integer, :default => 0
      field :pim, :type => Integer, :default => 0
      field :pen_minor, :type => Integer, :default => 0
      field :pen_major, :type => Integer, :default => 0
      field :pen_misc, :type => Integer, :default => 0
      field :pen_game, :type => Integer, :default => 0
      field :hat, :type => Integer, :default => 0
      field :plmkr, :type => Integer, :default => 0
      field :gordie, :type => Integer, :default => 0
      field :eject, :type => Integer, :default => 0
      
      field :g_gp, :type => Integer, :default => 0
      field :g_toi, :type => Integer, :default => 0
      field :g_sa, :type => Integer, :default => 0
      field :g_ga, :type => Integer, :default => 0
      field :g_sv, :type => Integer, :default => 0
      field :g_svp, :type => Float, :default => 0.00
      field :g_gaa, :type => Float, :default => 0.00
      field :g_so, :type => Integer, :default => 0
      field :g_soa, :type => Integer, :default => 0
      field :g_sog, :type => Integer, :default => 0
      field :g_sosvp, :type => Float, :default => 0.00
      field :g_regw, :type => Integer, :default => 0
      field :g_regl, :type => Integer, :default => 0
      field :g_otw, :type => Integer, :default => 0
      field :g_otl, :type => Integer, :default => 0
      field :g_sow, :type => Integer, :default => 0
      field :g_sol, :type => Integer, :default => 0
      field :g_totw, :type => Integer, :default => 0
      field :g_totl, :type => Integer, :default => 0
            
    end
    
    def clear_stats
      self.gp         = 0
      self.g          = 0
      self.a          = 0
      self.pts        = 0
      self.pen        = 0
      self.pim        = 0
      self.pen_minor  = 0
      self.pen_major  = 0
      self.pen_misc   = 0
      self.pen_game   = 0
      self.hat        = 0
      self.plmkr      = 0
      self.gordie     = 0
      self.eject      = 0
      self.g_gp       = 0
      self.g_toi      = 0
      self.g_sa       = 0
      self.g_ga       = 0
      self.g_svp      = 0
      self.g_gaa      = 0
      self.g_so       = 0
      self.g_soa      = 0
      self.g_sog      = 0
      self.g_sosvp    = 0
      self.g_regw     = 0
      self.g_regl     = 0
      self.g_otw      = 0
      self.g_otl      = 0
      self.g_sow      = 0
      self.g_sol      = 0
      self.g_totw     = 0
      self.g_totl     = 0
    end
    
    def add_stats stats
      return if stats.nil?
      self.gp         += stats.gp
      self.g          += stats.g
      self.a          += stats.a
      self.pts        += stats.pts
      self.pen        += stats.pen
      self.pim        += stats.pim
      self.pen_minor  += stats.pen_minor
      self.pen_major  += stats.pen_major
      self.pen_misc   += stats.pen_misc 
      self.pen_game   += stats.pen_game 
      self.hat        += stats.hat      
      self.plmkr      += stats.plmkr    
      self.gordie     += stats.gordie   
      self.eject      += stats.eject  
      self.g_gp       += stats.g_gp   
      self.g_toi      += stats.g_toi  
      self.g_sa       += stats.g_sa   
      self.g_ga       += stats.g_ga   
      self.g_sv       += stats.g_sv   
      self.g_svp      = g_sv.to_f / g_sa.to_f  
      self.g_gaa      += stats.g_gaa  
      self.g_so       += stats.g_so   
      self.g_soa      += stats.g_soa  
      self.g_sog      += stats.g_sog  
      self.g_sosvp    += stats.g_sosvp
      self.g_regw     += stats.g_regw 
      self.g_regl     += stats.g_regl 
      self.g_otw      += stats.g_otw  
      self.g_otl      += stats.g_otl  
      self.g_sow      += stats.g_sow  
      self.g_sol      += stats.g_sol  
      self.g_totw     += stats.g_totw 
      self.g_totl     += stats.g_totl 
    end
    
    def subtract_stats stats
      return if stats.nil?
      self.gp         -= stats.gp
      self.g          -= stats.g
      self.a          -= stats.a
      self.pts        -= stats.pts
      self.pen        -= stats.pen
      self.pim        -= stats.pim
      self.pen_minor  -= stats.pen_minor
      self.pen_major  -= stats.pen_major
      self.pen_misc   -= stats.pen_misc 
      self.pen_game   -= stats.pen_game 
      self.hat        -= stats.hat      
      self.plmkr      -= stats.plmkr    
      self.gordie     -= stats.gordie 
      self.eject      -= stats.eject  
      self.g_gp       -= stats.g_gp   
      self.g_toi      -= stats.g_toi  
      self.g_sa       -= stats.g_sa   
      self.g_ga       -= stats.g_ga   
      self.g_sv       -= stats.g_sv   
      self.g_svp      = g_sv.to_f / g_sa.to_f  
      self.g_gaa      -= stats.g_gaa  
      self.g_so       -= stats.g_so   
      self.g_soa      -= stats.g_soa  
      self.g_sog      -= stats.g_sog  
      self.g_sosvp    -= stats.g_sosvp
      self.g_regw     -= stats.g_regw 
      self.g_regl     -= stats.g_regl 
      self.g_otw      -= stats.g_otw  
      self.g_otl      -= stats.g_otl  
      self.g_sow      -= stats.g_sow  
      self.g_sol      -= stats.g_sol  
      self.g_totw     -= stats.g_totw 
      self.g_totl     -= stats.g_totl      
    end
    
    module ClassMethods
      
      def tokens(view)
        case view
        when "scoring"
          Hockey::Player::Record::SCORING
        when "penalties"
          Hockey::Player::Record::PENALTIES
        when "goaltending"
          Hockey::Player::Record::GOALTENDING
        end
      end
      
      def default_token(view)
        case view
        when "scoring"
          "pts"
        when "penalties"
          "pim"
        when "goaltending"
          "g_gaa"
        end       
      end
      
      def column(token)
        "boo"
        I18n.t("hockey.statistics.tokens.#{token}.col")
      end
      
    end
    
  end
end