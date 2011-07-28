::Sportified::Application.routes.draw do

  match "league" => "league/home#index", :as => :league, :via => :get

  match 'league(/:division_slug)/schedule' => 'league/schedule#index', :as => :league_schedule, :via => :get
  match 'league(/:division_slug)/scoreboard' => 'league/scoreboard#index', :as => :league_scoreboard, :via => :get
  match 'league/:division_slug(/:season_slug)/standings' => 'league/standings#index', :as => :league_standings, :via => :get
  match 'league(/:division_slug)(/:season_slug)/teams/' => 'league/teams#index', :as => :league_teams, :via => :get
  match "league/:division_slug" => "league/divisions#show", :as => :league_division, :via => :get

  match 'league/:division_slug/:season_slug/teams/:team_slug' => 'league/teams#show', :as => :league_team, :via => :get
  match 'league/:division_slug/:season_slug/teams/:team_slug/schedule' => 'league/teams#schedule', :as => :league_team_schedule, :via => :get
  match 'league/:division_slug/:season_slug/teams/:team_slug/roster' => 'league/teams#roster', :as => :league_team_roster, :via => :get

  match 'league/games/box_score/:id' => 'league/games#box_score', :as => :league_game_box_score, :via => :get

  namespace :admin do
    resources :standings_layouts do
      get 'columns', :on => :member
      resources :standings_columns do
        post 'push_left', :on => :member
        post 'push_right', :on => :member
      end      
    end
    resource :league, :only => :show
    resources :divisions
    resources :seasons
    resources :clubs
    resources :venues
    resources :teams, :shallow => true do
      resources :players
    end
    resources :events
    resources :games do
      resource :statsheet, :only => [:edit]
    end
    resources :game_results, :only => [:index, :edit, :update]
    resources :hockey_statsheets, :only => [:edit, :update] do
      resources :players, :controller => "hockey_players" do
        post 'load', :on => :collection        
        post 'reload', :on => :collection
      end
      resources :goals, :controller => "hockey_goals"
      resources :penalties, :controller => "hockey_penalties"
      resources :goaltenders, :controller => "hockey_goaltenders"
    end
  end



end

