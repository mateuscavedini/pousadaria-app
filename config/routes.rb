Rails.application.routes.draw do
  devise_for :guests
  devise_for :owners, controllers: { registrations: 'registrations' }
  get "up" => "rails/health#show", as: :rails_health_check
  root to: 'home#index'

  resources :guesthouses, only: [:show, :new, :create, :edit, :update] do
    post 'activated', on: :member
    post 'deactivated', on: :member
    get 'search_by_city', on: :collection
    get 'search_by_term', on: :collection

    resources :rooms, only: [:new, :create]
  end

  resources :rooms, only: [:show, :edit, :update] do
    post 'activated', on: :member
    post 'deactivated', on: :member

    resources :seasonal_rates, only: [:new, :create]
  end

  resources :seasonal_rates, only: [:edit, :update] do
    post 'activated', on: :member
    post 'deactivated', on: :member
  end
  
  get 'my-guesthouse', to: 'guesthouses#my_guesthouse'
end
