::Sportified::Application.routes.draw do
  
  get '/pages', :to => 'pages#index'
  get '/pages/:id', :to => 'pages#show', :as => :page, :constraints => { :id => /[a-f0-9]{24}/ }
  get '/pages/*path', :to => 'pages#show', :as => :page

end
