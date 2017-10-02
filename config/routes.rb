::Sportified::Application.routes.draw do

  get 'pack' => 'client#index'

  mount Rms::Engine => '/registrar', as: 'rms'
  mount ExceptionLogger::Engine => "/exception_logger"

  # namespace :registrar do
  #   resources :registrables
  #   resources :registration_types, :only => [], :shallow => true do
  #     resources :registrations, :only => [:new, :create, :show] do
  #       get 'payment', :on => :member
  #     end
  #   end
  #   resources :registrations, :only => [:index]
  # end

  match "markdown" => "markdown#preview", :as => :markdown, :via => :post

  resources :credit_cards, :only => [:create]

  namespace :api do
    resources :tenants
    resources :events, :only => [ :index ]
    resources :programs, :only => [ :index ]
    resources :games, :only => [ :index, :show ] do
      get 'statify', :on => :member
      put 'statify', :on => :member
    end
    namespace :hockey do
      resources :statsheets, :only => [ :show ]
      resources :goals, :only => [ :create, :update ]
    end
    namespace :league do
      resources :programs, :only => [ :index ]
      resources :seasons, :only => [ :index ]
      resources :divisions, :only => [ :index ]
      resources :teams, :only => [ :index ]
      resources :games do
        match :batch_create, via: [:post, :options], on: :collection
      end
      resources :players do
        match :batch_create, via: [:post, :options], on: :collection
      end
    end
    resources :locations, :only => [ :index ]
  end

  get 'game_result/edit'

  get 'game_result/update'

  get 'commish/index'

  resources :posts, :only => [ :show ]

  get "dashboard/index"

  root :to => "pages#show"

  match 'users/auth/facebook/setup' => 'sessions#setup', via: :get
  match 'users/auth/:provider/callback' => 'authentications#create', via: :get
  devise_for :users, :controllers => {:registrations => "registrations", :sessions => "sessions"}
  devise_scope :user do
    get '/users/sign_out' => 'sessions#destroy'
  end

  resources :authentications

  match 'user/schedule' => 'users#schedule', via: :get, as: :user_schedule
  match 'user/teams' => 'users#teams', via: :get, as: :user_teams
  match 'user/subscribe' => 'users#subscribe', via: :post, as: :subscribe_user
  match 'users/:id/schedule' => 'users#schedule', via: :get, as: :users_schedule


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

  resources :programs, only: [:index, :show, :delete], param: :slug

  match "league/:league_slug/schedule/:division_slug" => "schedule#index"                                       , :as => :league_schedule        , :via => :get
  match "league/:league_slug/scoreboard/:division_slug" => "scoreboard#index"                                   , :as => :league_scoreboard      , :via => :get
  match "league/:league_slug/standings/:division_slug(/:season_slug)" => "standings#index"                      , :as => :league_standings       , :via => :get
  match "league/:league_slug/statistics/:division_slug(/:season_slug)" => "statistics#index"                    , :as => :league_statistics      , :via => :get
  match "league/:league_slug/statistics/:division_slug/:season_slug/:view" => "statistics#show"                 , :as => :league_statistic       , :via => :get
  match "league/:league_slug/teams/:division_slug(/:season_slug)" => "teams#index"                              , :as => :league_teams           , :via => :get
  match "league/:league_slug/teams/:division_slug/:season_slug/:team_slug/schedule" => "teams#schedule"         , :as => :league_team_schedule   , :via => :get
  match "league/:league_slug/teams/:division_slug/:season_slug/:team_slug/roster" => "teams#roster"             , :as => :league_team_roster     , :via => :get
  match "league/:league_slug/teams/:division_slug/:season_slug/:team_slug/statistics" => "teams#statistics"     , :as => :league_team_statistics , :via => :get
  match "league/:league_slug/players/:division_slug(/:season_slug)" => "players#index"                          , :as => :league_players         , :via => :get
  match "league/:league_slug/players/:division_slug/:season_slug/:team_slug/:player_slug/:id" => "players#show" , :as => :league_player          , :via => :get
  match "league/:league_slug/players/:division_slug/:season_slug/:team_slug/:player_slug/:id/career" => "players#career" , :as => :league_player_career          , :via => :get
  match "league/:league_slug/game/:id/box_score" => "games#box_score"                                           , :as => :league_game_box_score  , :via => :get


  resources :seasons, :only => [], :shallow => true do
    resources :teams, :only => [ :new, :create, :edit, :update, :delete]
  end

  namespace :admin do

    resources :programs, :only => [:index, :destroy]
    namespace :activity do
      resources :programs, :except => [:index, :destroy]
      resources :sessions, :except => [:index, :destroy]
    end
    namespace :league do
      resources :programs, :except => [:index, :destroy], :shallow => true do
        resources :divisions, :except => [:show] do
          resources :teams, :except => [:index] do
            resources :players, :except => [:index, :show]
          end
        end
        resources :seasons
      end
      resources :events, :only => [:new, :create, :edit, :update]
      resources :games, :only => [:index, :new, :create, :edit, :update]
    end

    # resources :seasons, :only => [:index, :show, :create, :new, :edit, :update, :delete], :shallow => true do
    #   resources :divisions, :except => :index
    #   resources :teams, :except => :index do
    #     resources :players
    #   end
    # end

    resources :teams, :only => :index
    # resources :events
    resources :games, :only => [] do
      resource :result, :controller => :game_result, :only => [:edit, :update]
      resource :statsheet, :only => [:edit] do
        get 'print', on: :member
      end
    end

    resources :clubs
    resources :locations do
      resources :playing_surfaces
      resources :locker_rooms
    end
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
