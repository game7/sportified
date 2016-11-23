Rms::Engine.routes.draw do

  resources :items
  resources :forms

  resources :registrations, :only => [:index] do
    collection do
      get 'all'
    end
    member do
      get 'checkout', to: 'checkout#redirect', as: :checkout
      get 'checkout/payment'
      patch 'checkout/payment', to: 'checkout#charge', as: :checkout_charge
      get 'checkout/confirmation'
      get 'checkout/:form_id', to: 'checkout#form', as: :checkout_form
      patch 'checkout/:form_id', to: 'checkout#submit', as: :checkout_submit
    end
  end

  resources :variants, :only => [] do
    get 'register', on: :member
  end

  resources :registrations, :only => [:show]

  root 'items#index'

end
