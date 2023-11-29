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
    resources :reviews, only: [:index]
  end

  resources :rooms, only: [:show, :edit, :update] do
    post 'activated', on: :member
    post 'deactivated', on: :member

    resources :seasonal_rates, only: [:new, :create]
    resources :bookings, only: [:new, :create]
    get 'validate_booking', to: 'bookings#validate'
  end

  resources :seasonal_rates, only: [:edit, :update] do
    post 'activated', on: :member
    post 'deactivated', on: :member
  end

  resources :bookings, only: [:show] do
    post 'ongoing', on: :member
    post 'finished', on: :member
    post 'canceled', on: :member
    get 'confirmed-check-out', on: :member

    resources :reviews, only: [:new, :create]
  end
  
  resources :reviews, only: [] do
    get 'new-reply', on: :member
    post 'save-reply', on: :member
  end
  
  get 'my-guesthouse', to: 'guesthouses#my_guesthouse'
  get 'my-bookings', to: 'bookings#my_bookings'
  get 'my-ongoing-bookings', to: 'bookings#my_ongoing_bookings'
  get 'my-reviews', to: 'reviews#my_reviews'
end
