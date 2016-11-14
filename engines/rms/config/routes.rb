Rms::Engine.routes.draw do

  resources :items
  resources :forms

  resources :variants, :only => [], :shallow => true do
    resources :registrations, :only => [:new, :create, :show]
  end

  resources :registrations, :only => [:index]

end
