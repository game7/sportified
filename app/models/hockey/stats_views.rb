module Hockey
  module StatsViews

    VIEWS = %w[scoring penalties goaltending]

    SCORING = %w[gp g a pts hat plmkr gordie]
    PENALTIES = %w[gp pen pim pen_minor pen_major pen_misc pen_game eject]
    GOALTENDING = %w[g_gp g_toi g_sa g_ga g_sv g_svp g_gaa] 
  
  end
end