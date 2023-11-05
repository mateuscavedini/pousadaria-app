Rails.application.routes.draw do
  devise_for :owners, controllers: { registrations: 'registrations' }
  get "up" => "rails/health#show", as: :rails_health_check
  root to: 'home#index'

  resources :guesthouses, only: [:show, :new, :create, :edit, :update] do
    post 'activated', on: :member
    post 'deactivated', on: :member
  end
  get 'my-guesthouse', to: 'guesthouses#my_guesthouse'
end
