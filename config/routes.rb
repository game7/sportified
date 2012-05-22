::Sportified::Application.routes.draw do

  get "dashboard/index"

  root :to => "pages#show"
  
  match 'users/auth/facebook/setup' => 'sessions#setup'
  match 'users/auth/:provider/callback' => 'authentications#create'
  devise_for :users
  resources :users, :only => :show
  resources :authentications

  namespace :host do
    root :to => "dashboard#index"    
    resources :tenants
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

  match "programs/:league_slug/schedule(/:season_slug)" => "schedule#index", :as => :schedule, :via => :get
  match "programs/standings/:league_slug(/:season_slug)" => "standings#index", :as => :standings, :via => :get
  match "programs/:league_slug/scoreboard" => "scoreboard#index", :as => :scoreboard, :via => :get  

  match "programs/players/:league_slug(/:season_slug)" => "players#index", :as => :players, :via => :get
  match "programs/:league_slug/game/:id/box_score" => "games#box_score", :as => :game_box_score, :via => :get
  
  match "programs/teams/:league_slug(/:season_slug)" => "teams#index", :as => :teams, :via => :get
  
  match "programs/statistics/:league_slug(/:season_slug)" => "statistics#index", :as => :statistics, :via => :get
  
  match "programs/:league_slug/teams/:season_slug/:team_slug/schedule" => "teams#schedule", :as => :team_schedule, :via => :get
  match "programs/:league_slug/teams/:season_slug/:team_slug/roster" => "teams#roster", :as => :team_roster, :via => :get
  match "programs/:league_slug/teams/:season_slug/:team_slug/statistics" => "teams#statistics", :as => :team_statistics, :via => :get

  namespace :admin do
    resources :leagues

    resources :seasons, :shallow => true do
      resources :divisions, :only => [:new, :create, :edit, :update, :destroy]
      resources :teams, :except => :index do
        resources :players      
      end
    end
    resources :teams, :only => :index
    resources :events
    resources :games do
      resource :statsheet, :only => [:edit]
      resource :result, :only => [:new, :create, :destroy], :module => :games
    end

    resources :clubs
    resources :venues
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
  
  match "admin/game_results" => "admin/games/results#index", :as => :admin_game_results, :via => :get
  
  get '/pages/*path', :to => 'pages#show', :as => :page_friendly  
  
  namespace :admin do
    resources :pages do
      post 'position', :on => :collection
      resources :blocks, :only => [ :index, :create, :destroy ] do
        post 'position', :on => :collection
      end
      namespace :blocks, :except => [:edit, :update] do
        resources :contacts, :only => [:edit, :update]
        resources :texts, :only => [:edit, :update]
        resources :images, :only => [:edit, :update]
        resources :documents, :only => [:edit, :update]
        resources :markups, :only => [:edit, :update]
      end
    end    
  end
  

end
