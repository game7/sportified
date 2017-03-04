Rms::Engine.routes.draw do


  resources :form_packets
  get 'dashboard', to: 'dashboard#index'

  resources :items
  resources :forms
  
  resources :form_packets, shallow: true do
    resources :form_templates, shallow: true do
      resources :form_elements, except: [:index, :show]
    end
  end

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
    resources :registrations, :only => [:new, :create]
    get 'register', on: :member
  end

  resources :registrations, :only => [:show]

  root 'items#index'

end
