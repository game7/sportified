::Sportified::Application.routes.draw do

  get "dashboard/index"

  root :to => "welcome#index"
  
  match 'users/auth/facebook/setup' => 'sessions#setup'
  match 'users/auth/:provider/callback' => 'authentications#create'
  devise_for :users
  resources :users, :only => :show
  resources :authentications

  namespace :host do
    root :to => "dashboard#index"    
    resources :sites
    resources :users
    match 'status' => 'dashboard#status'
  end
  

  namespace :admin do
    root :to => "dashboard#index"
    resources :users do
      resources :user_roles, :only => [ :create, :destroy ]
    end
    resource :site#, :only => [ :edit, :update ]
  end



  #match "league" => "league/home#index", :as => :league, :via => :get
  #
  #match 'league(/:division_slug)/schedule' => 'league/schedule#index', :as => :league_schedule, :via => :get
  #match 'league(/:division_slug)/scoreboard' => 'league/scoreboard#index', :as => :league_scoreboard, :via => :get
  #match 'league/:division_slug(/:season_slug)/standings' => 'league/standings#index', :as => :league_standings, :via => :get
  #match 'league(/:division_slug)(/:season_slug)/teams/' => 'league/teams#index', :as => :league_teams, :via => :get
  ##match "league/:division_slug" => "league/divisions#show", :as => :league_division, :via => :get
  #
  #match 'league/:division_slug/:season_slug/teams/:team_slug' => 'league/teams#show', :as => :league_team, :via => :get
  #match 'league/:division_slug/:season_slug/teams/:team_slug/schedule' => 'league/teams#schedule', :as => :league_team_schedule, :via => :get
  #match 'league/:division_slug/:season_slug/teams/:team_slug/roster' => 'league/teams#roster', :as => :league_team_roster, :via => :get
  #
  #match 'league/games/box_score/:id' => 'league/games#box_score', :as => :league_game_box_score, :via => :get

  namespace :league do
    namespace :admin do
      root :to => "dashboard#show"
      resources :standings_layouts do
        get 'columns', :on => :member
        resources :standings_columns do
          post 'push_left', :on => :member
          post 'push_right', :on => :member
        end      
      end
      resources :seasons, :shallow => true do
        resources :divisions, :only => [:new, :create, :edit, :update, :destroy] do
        end
        resources :teams, :except => :index do
        end
      end
      resources :clubs
      resources :venues
      resources :teams, :only => [:index], :shallow => true do
        resources :players
      end
      resources :events
      resources :games, :only => [:new, :create, :edit, :update]  do
        resource :statsheet, :only => [:edit]
        resource :game_result, :only => [:new, :create, :destroy]
      end
      resources :game_uploads do
        post 'complete', :on => :member
      end
      resources :game_results, :only => [:index]
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

end
