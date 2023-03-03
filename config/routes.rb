Rails.application.routes.draw do # rubocop:disable Metrics/BlockLength
  get 'screen' => 'screen#show'

  resources :products, only: %i[index show]
  resources :variants, only: [] do
    resources :registrations, only: %i[new create]
  end
  resources :registrations, only: %i[index show] do
    member do
      get :collect
      get :confirm
    end
  end
  namespace :admin do
    get 'dashboard/index'
    get 'products/dashboard' => 'products/dashboard#index'
    resources :products
    resources :products, module: :products, only: [] do
      resources :registrations, only: [:index]
      resources :attendance, only: [:index]
    end
    resources :registrations, only: %i[index show] do
      patch :abandon, on: :member
      patch :cancel, on: :member
      patch :toggle_check_in, on: :member
    end
    resources :form_packets, shallow: true do
      resources :form_templates, shallow: true do
        resources :form_elements, except: %i[index show]
      end
    end
  end

  # redirect from legacy registrar routes
  get 'registrar/items/:id', to: redirect('/products/%<id>s')
  get 'registrar/items', to: redirect('/products')
  get 'registrar/admin(/*route)', to: redirect('/admin/products/dashboard')

  passwordless_for :users

  namespace :host do
    resources :visits, only: %i[index show]
    resources :events, only: %i[index show]
    resources :exceptions, only: :index
  end

  resources :stripe_connects, only: :create

  resources :chromecasts, only: :show

  get 'cast/index'

  get 'casts' => 'casts#index', :as => :casts
  get 'casts/:slug' => 'casts#show', :as => :cast

  unless Rails.env.production?
    resources :tenants, only: :index do
      put :select, on: :member
    end
  end

  get 'pack' => 'client#index'

  match 'markdown' => 'markdown#preview', :as => :markdown, :via => :post

  namespace :api do # rubocop:disable Metrics/BlockLength
    resources :tenants
    resources :events, only: [:index]
    resources :programs, only: [:index]
    resources :games, only: %i[index show] do
      get 'statify', on: :member
      put 'statify', on: :member
    end
    namespace :hockey do
      resources :statsheets, only: [:show]
      resources :goals, only: %i[create update]
    end
    namespace :general do
      resources :events, only: [] do
        match :batch_create, via: %i[post options], on: :collection
      end
    end
    namespace :league do
      resources :programs, only: [:index]
      resources :seasons, only: [:index]
      resources :divisions, only: [:index]
      resources :teams, only: [:index]
      resources :games do
        match :batch_create, via: %i[post options], on: :collection
      end
      resources :practices do
        match :batch_create, via: %i[post options], on: :collection
      end
      resources :players do
        match :batch_create, via: %i[post options], on: :collection
      end
    end
    resources :locations, only: [:index]
    resources :tags, only: %i[index update]
  end

  get 'game_result/edit'

  get 'game_result/update'

  get 'commish/index'

  resources :posts, only: [:show]

  get 'dashboard/index'

  root to: 'pages#show'

  resources :authentications

  match 'user/schedule' => 'users#schedule', via: :get, as: :user_schedule
  match 'user/teams' => 'users#teams', via: :get, as: :user_teams
  match 'user/subscribe' => 'users#subscribe', via: :post, as: :subscribe_user
  match 'users/:id/schedule' => 'users#schedule', via: :get, as: :users_schedule

  namespace :host do
    root to: 'dashboard#index'
    resources :tenants
    resources :users
    get 'status' => 'dashboard#status'
  end

  namespace :admin do
    root to: 'dashboard#index'

    get 'uploads(/*path)', to: 'uploads#index', as: :uploads

    resources :users, only: %i[index show update] do
      scope module: :users do
        resources :registrations, only: [:index]
        resources :teams, only: [:index]
        resources :vouchers, only: %i[index create]
      end
    end
  end

  resources :programs, only: %i[index show delete], param: :slug

  match 'schedule' => 'schedule#index', :as => :schedule, :via => :get

  match 'league/:league_slug/schedule/:division_slug' => 'league/schedule#index', :as => :league_schedule, :via => :get
  match 'league/:league_slug/scoreboard/:division_slug' => 'scoreboard#index', :as => :league_scoreboard, :via => :get
  match 'league/:league_slug/standings/:division_slug(/:season_slug)' => 'standings#index', :as => :league_standings,
        :via => :get
  match 'league/:league_slug/statistics/:division_slug(/:season_slug)' => 'statistics#index',
        :as => :league_statistics, :via => :get
  match 'league/:league_slug/statistics/:division_slug/:season_slug/:view' => 'statistics#show',
        :as => :league_statistic, :via => :get
  match 'league/:league_slug/teams/:division_slug(/:season_slug)' => 'league/teams#index', :as => :league_teams,
        :via => :get
  match 'league/:league_slug/teams/:division_slug/:season_slug/:team_slug/schedule' => 'league/teams#schedule',
        :as => :league_team_schedule, :via => :get
  match 'league/:league_slug/teams/:division_slug/:season_slug/:team_slug/roster' => 'league/teams#roster',
        :as => :league_team_roster, :via => :get
  match 'league/:league_slug/teams/:division_slug/:season_slug/:team_slug/statistics' => 'league/teams#statistics',
        :as => :league_team_statistics, :via => :get
  match 'league/:league_slug/players/:division_slug(/:season_slug)' => 'players#index', :as => :league_players,
        :via => :get
  match 'league/:league_slug/players/:division_slug/:season_slug/:team_slug/:player_slug/:id' => 'players#show',
        :as => :league_player, :via => :get
  match 'league/:league_slug/players/:division_slug/:season_slug/:team_slug/:player_slug/:id/career' => 'players#career',
        :as => :league_player_career, :via => :get
  match 'league/:league_slug/game/:id/box_score' => 'league/games#box_score', :as => :league_game_box_score,
        :via => :get

  resources :seasons, only: [], shallow: true do
    resources :teams, only: %i[new create edit update delete], module: :league
  end

  resources :cast, only: :index

  namespace :admin do # rubocop:disable Metrics/BlockLength
    resources :chromecasts, except: [:show]
    resources :screens, except: [:show]

    resources :programs, only: %i[index destroy]
    namespace :league do
      resources :programs, except: %i[index destroy], shallow: true do
        resources :divisions, except: [:show] do
          resources :teams, except: [:index] do
            resources :players, except: %i[index show]
          end
        end
        resources :seasons
      end
      resources :events, only: %i[new create edit update]
      resources :games, only: %i[index new create edit update]
      resources :practices, only: %i[new create edit update]
    end

    # resources :seasons, :only => [:index, :show, :create, :new, :edit, :update, :delete], :shallow => true do
    #   resources :divisions, :except => :index
    #   resources :teams, :except => :index do
    #     resources :players
    #   end
    # end

    resources :teams, only: :index
    # resources :events
    resources :games, only: [] do
      resource :result, controller: :game_result, only: %i[edit update]
      resource :statsheet, only: [:edit] do
        get 'print', on: :member
      end
    end

    resources :clubs
    resources :locations, shallow: true do
      resources :playing_surfaces, except: %i[index show]
      resources :locker_rooms, except: %i[index show]
    end

    resources :events, only: %i[index update destroy] do
      get :proto, on: :collection
    end
    namespace :events do
      resources :locker_rooms, only: [] do
        post :assign, on: :collection
      end
    end

    namespace :general do
      resources :events, only: %i[show new create edit update]
    end
    resources :game_imports do
      post 'complete', on: :member
    end
    resources :player_imports do
      post 'complete', on: :member
    end

    resources :hockey_statsheets, only: %i[edit update] do
      post 'post', on: :member
      post 'unpost', on: :member
      resources :players, controller: 'hockey_players' do
        post 'load', on: :collection
        post 'reload', on: :collection
      end
      resources :goals, controller: 'hockey_goals'
      resources :penalties, controller: 'hockey_penalties'
      resources :goaltenders, controller: 'hockey_goaltenders' do
        post 'autoload', on: :collection
      end
    end

    # resources :standings_layouts do
    #  get 'columns', :on => :member
    #  resources :standings_columns do
    #    post 'push_left', :on => :member
    #    post 'push_right', :on => :member
    #  end
    # end
  end

  # match "admin/seasons(/:id)" => "admin/seasons#show", :as => :admin_seasons, :via => :get

  match 'admin/game_results' => 'admin/games/results#index', :as => :admin_game_results, :via => :get

  resources :pages, except: [:show] do
    member do
      post :move_up
      post :move_down
    end
    resources :sections, only: %i[create destroy] do
      post 'position', on: :collection
    end
    resources :blocks do
      post 'position', on: :collection
    end
    namespace :blocks do # :except => [:edit, :update] do
      resources :contacts, only: %i[edit update]
      resources :texts, only: %i[edit update]
      resources :images, only: %i[edit update]
      resources :feeds, only: %i[edit update]
      resources :documents, only: %i[edit update]
      resources :markups, only: %i[edit update]
      resources :carousels, only: %i[edit update]
      resources :event_feeds, only: %i[edit update]
    end
  end

  get '/pages/*path', to: 'pages#show', as: :page_friendly, via: :get

  namespace :admin do
    resources :posts
  end

  namespace :next do
    namespace :admin do
      root to: 'dashboard#index'
      get 'planner' => 'planner#index'
      get 'calendar' => 'calendar#index'
      namespace :general do
        resources :events, only: %i[new create edit update]
      end
      namespace :league do
        resources :games, only: %i[new create edit update]
        resources :practices, only: %i[new create edit update]
        resources :events, only: %i[new create edit update]
      end
      resources :posts, only: %i[index show new create edit update]
      resources :locations, only: %i[index show new create edit update]
    end
  end

  namespace :active_storage do
    resources :blobs, only: %i[index create]
  end
end
