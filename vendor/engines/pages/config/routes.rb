::Sportified::Application.routes.draw do
  
  #get '/pages/:id', :to => 'pages#show', :as => :page, :constraints => { :id => /[a-f0-9]{24}/ }
  get '/p/*path', :to => 'pages#show', :as => :page_friendly

  resources :pages do
    resources :layouts, :only => [ :index, :create ] do
      post 'position', :on => :collection
    end
    resources :blocks, :only => [ :index, :create, :destroy ] do
      post 'position', :on => :collection
    end
    resources :text_blocks, :only => [ :create, :edit, :update ]

  end

end
