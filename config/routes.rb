::Sportified::Application.routes.draw do


  mount_ember_app :calendar, to: 'apps/calendar'
  mount_ember_app :scorebook, to: 'apps/scorebook'

  namespace :api do
    resources :events, :only => [ :index ]
    resources :games, :only => [ :index, :show ] do
      get 'statify', :on => :member
      put 'statify', :on => :member
    end
    namespace :hockey do
      resources :statsheets, :only => [ :show ]
      resources :goals, :only => [ :create, :update ]
    end
  end

  get 'game_result/edit'

  get 'game_result/update'

  get 'commish/index'

  resources :posts, :only => [ :show ]

  get "dashboard/index"

  root :to => "pages#show"

  match 'users/auth/facebook/setup' => 'sessions#setup', via: :get
  match 'users/auth/:provider/callback' => 'authentications#create', via: :get
  devise_for :users
  resources :users, :only => :show
  resources :authentications

  namespace :host do
    root :to => "dashboard#index"
    resources :tenants
    resources :users
    get 'status' => 'dashboard#status'
  end

  namespace :admin do
    root :to => "dashboard#index"
    resources :users do
      resources :user_roles, :only => [ :create, :destroy ]
    end
  end

  match "programs/:league_slug/schedule" => redirect("/programs/schedule/%{league_slug}"), :via => :get
  match "programs/schedule(/:league_slug)" => "schedule#index", :as => :schedule, :via => :get

  match "programs/standings/:league_slug(/:season_slug)" => "standings#index", :as => :standings, :via => :get
  match "programs/:league_slug/scoreboard" => "scoreboard#index", :as => :scoreboard, :via => :get

  match "programs/players/:league_slug(/:season_slug)" => "players#index", :as => :players, :via => :get
  match "programs/player/:id" => "players#show", :as => :player, :via => :get

  match "programs/:league_slug/game/:id/box_score" => "games#box_score", :as => :game_box_score, :via => :get

  match "programs/teams/:league_slug(/:season_slug)" => "teams#index", :as => :teams, :via => :get

  match "programs/statistics/:league_slug(/:season_slug)" => "statistics#index", :as => :statistics, :via => :get
  match "programs/statistics/:league_slug/:season_slug/:view" => "statistics#show", :as => :statistic, :via => :get

  match "programs/:league_slug/teams/:season_slug/:team_slug/schedule" => "teams#schedule", :as => :team_schedule, :via => :get
  match "programs/:league_slug/teams/:season_slug/:team_slug/roster" => "teams#roster", :as => :team_roster, :via => :get
  match "programs/:league_slug/teams/:season_slug/:team_slug/statistics" => "teams#statistics", :as => :team_statistics, :via => :get


  resources :seasons, :only => [], :shallow => true do
    resources :teams, :only => [ :new, :create, :edit, :update, :delete]
  end

  namespace :admin do
    resources :leagues

    resources :seasons, :only => [:index, :show, :create, :new, :edit, :update, :delete], :shallow => true do
      resources :divisions, :except => :index
      resources :teams, :except => :index do
        resources :players
      end
    end
    resources :divisions, :only => :index
    resources :teams, :only => :index
    resources :events
    resources :games do
      resource :result, :controller => :game_result, :only => [:edit, :update]
      resource :statsheet, :only => [:edit]
    end

    resources :clubs
    resources :locations
    resources :events
    resources :game_imports do
      post 'complete', :on => :member
    end
    resources :player_imports do
      post 'complete', :on => :member
    end

    resources :hockey_statsheets, :only => [:edit, :update] do
      post 'post', :on => :member
      post 'unpost', :on => :member
      resources :players, :controller => "hockey_players" do
        post 'load', :on => :collection
        post 'reload', :on => :collection
      end
      resources :goals, :controller => "hockey_goals"
      resources :penalties, :controller => "hockey_penalties"
      resources :goaltenders, :controller => "hockey_goaltenders" do
        post 'autoload', :on => :collection
      end
    end

    #resources :standings_layouts do
    #  get 'columns', :on => :member
    #  resources :standings_columns do
    #    post 'push_left', :on => :member
    #    post 'push_right', :on => :member
    #  end
    #end
  end

  #match "admin/seasons(/:id)" => "admin/seasons#show", :as => :admin_seasons, :via => :get

  match "admin/game_results" => "admin/games/results#index", :as => :admin_game_results, :via => :get

  resources :pages, :except => [ :show ] do
    post 'position', :on => :collection
    resources :sections, :only => [ :create, :destroy ] do
      post 'position', :on => :collection
    end
    resources :blocks do
      post 'position', :on => :collection
    end
    namespace :blocks do #:except => [:edit, :update] do
      resources :contacts, :only => [:edit, :update]
      resources :texts, :only => [:edit, :update]
      resources :images, :only => [:edit, :update]
      resources :documents, :only => [:edit, :update]
      resources :markups, :only => [:edit, :update]
      resources :carousels, :only => [:edit, :update]
    end
  end

  get '/pages/*path', :to => 'pages#show', :as => :page_friendly, :via => :get


  namespace :admin do
    resources :posts
  end


end
