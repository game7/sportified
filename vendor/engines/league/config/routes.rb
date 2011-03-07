::Sportified::Application.routes.draw do

  match "league" => "league/home#index", :as => :league, :via => :get
  match "league/:division_slug/home" => "league/divisions#show", :as => :league_division_friendly, :via => :get

  match 'league/:division_slug/schedule' => 'league/games#index', :as => :league_division_schedule_friendly, :via => :get

  match 'league/:division_slug/scoreboard' => 'league/scoreboard#index', :as => :league_division_scoreboard_friendly, :via => :get
  
  match 'league/:division_slug(/:season_slug)/standings' => 'league/standings#index', :as => :league_division_standings_friendly, :via => :get

  match 'league/:division_slug(/:season_slug)/teams/' => 'league/teams#index', :as => :league_division_teams_friendly, :via => :get

  match 'league/:division_slug/:season_slug/teams/:team_slug' => 'league/teams#show', :as => :league_team_friendly, :via => :get
  match 'league/:division_slug/:season_slug/teams/:team_slug/schedule' => 'league/teams#schedule', :as => :league_team_schedule_friendly, :via => :get

  match 'league/:division_slug/:season_slug/:team_slug/roster' => 'league/players#index', :as => :league_team_roster_friendly, :via => :get

  namespace :admin do
    resources :divisions
    resources :seasons
  end

  namespace :league do
    resources :seasons
    resources :divisions, :shallow => true do
      resources :games do
        resource :result, :controller => "game_result"
      end
      resources :teams do
        resources :players
      end
    end
  end

  namespace :league do
    resources :divisions, :only => [] do
      resources :standings_columns do
        post 'push_left', :on => :member
        post 'push_right', :on => :member
      end
    end
  end

end

