Rails.application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  devise_for :users
  get "up" => "rails/health#show", as: :rails_health_check

  resources :assistants, only: [:show, :edit, :update]
  resources :company
  resources :users
  resources :leads
  resources :conversations
  resources :option_types

  resources :products do
    patch :scrape, on: :member
  end

  namespace :public do
    resources :conversations
  end

  namespace :api do
    namespace :v1 do
      resources :assistants, only: [:show]
      post "auth/google_login", to: "auth#google_login"
    end
  end

  root "pages#home"
end
