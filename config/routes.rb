Rails.application.routes.draw do
  devise_for :users
  resources :stores

  resources :stores do
    resources :products
  end

  scope :buyers do
    resources :orders, only: [:index, :create, :update, :destroy]
  end

  get "listing" => "products#listing"

  post "new" => "registrations#create", as: :create_registration
  get "me" => "registrations#me"
  post "sign_in" => "registrations#sign_in"

  root to: "welcome#index"
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
end
