::Sportified::Application.routes.draw do
  get '/pages', :to => 'pages#index'
  get '/pages/:id', :to => 'pages#show', :as => :page

end
