Rms::Engine.routes.draw do

  resources :items
  resources :forms

  resources :registrations, :only => [:index] do
    get 'all', on: :collection
  end

  resources :variants, :only => [] do
    get 'register', on: :member
  end

  resources :registrations, :only => [:show]

  root 'items#index'

end
