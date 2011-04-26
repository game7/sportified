::Sportified::Application.routes.draw do
  
  #get '/pages/:id', :to => 'pages#show', :as => :page, :constraints => { :id => /[a-f0-9]{24}/ }
  get '/p/*path', :to => 'pages#show', :as => :page_friendly

  resources :pages do
    get 'manage', :on => :member
    resources :blocks, :only => [ :destroy ] do
      post 'move_up', :on => :member
      post 'move_down', :on => :member
      post 'move_top', :on => :member
      post 'move_bottom', :on => :member
    end
    resources :text_blocks, :only => [ :create, :edit, :update ]
  end

end
