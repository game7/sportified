Rms::Engine.routes.draw do

  resources :items
  resources :forms

  resources :registrations, :only => [:index] do
    get 'all', on: :collection
  end

  resources :variants, :only => [], :shallow => true do
    resources :registrations, :only => [:new, :create, :show]
  end

  root 'items#index'

end
