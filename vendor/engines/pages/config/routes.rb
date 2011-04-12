::Sportified::Application.routes.draw do
  
  #get '/pages/:id', :to => 'pages#show', :as => :page, :constraints => { :id => /[a-f0-9]{24}/ }
  get '/pages/-/*path', :to => 'pages#show', :as => :page

  resources :pages do
    resources :blocks, :only => [ :destroy ] do
      post 'move_up', :on => :member
      post 'move_down', :on => :member
      post 'move_top', :on => :member
      post 'move_bottom', :on => :member
    end
    resources :text_blocks, :only => [ :create, :update ]
  end

end
