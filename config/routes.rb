Sportified::Application.routes.draw do




  get "home/index"

  root :to => "home#index"
  devise_for :users
  resources :users, :only => :show

  match "league" => "league/home#index", :as => :league, :via => :get
  match "league/:division_slug/home" => "league/divisions#show", :as => :league_division_friendly, :via => :get

  match 'league/:division_slug/schedule' => 'league/games#index', :as => :league_division_schedule_friendly, :via => :get

  match 'league/:division_slug/scoreboard' => 'league/scoreboard#index', :as => :league_division_scoreboard_friendly, :via => :get
  
  match 'league/:division_slug(/:season_slug)/standings' => 'league/standings#index', :as => :league_division_standings_friendly, :via => :get

  match 'league/:division_slug(/:season_slug)/teams/' => 'league/teams#index', :as => :league_division_teams_friendly, :via => :get

  match 'league/:division_slug/:season_slug/teams/:team_slug' => 'league/teams#show', :as => :league_team_friendly, :via => :get
  match 'league/:division_slug/:season_slug/teams/:team_slug/schedule' => 'league/teams#schedule', :as => :league_team_schedule_friendly, :via => :get

  match 'league/:division_slug/:season_slug/:team_slug/roster' => 'league/players#index', :as => :league_team_roster_friendly, :via => :get

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


  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => "welcome#index"

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
