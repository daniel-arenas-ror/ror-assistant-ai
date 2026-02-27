Rails.application.routes.draw do
  if Rails.env.development?
    mount GraphiQL::Rails::Engine, at: "/graphiql", graphql_path: "/graphql"
  end
  post "/graphql", to: "graphql#execute"
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  devise_for :users
  get "up" => "rails/health#show", as: :rails_health_check

  resources :assistants, only: [:show, :edit, :update]
  resources :company
  resources :users
  resources :leads
  resources :conversations
  resources :option_types do
    collection do
      get :add_value
    end
  end

  resources :products do
    patch :scrape, on: :member
    member do
      delete :purge_image
    end
  end

  resources :categories

  namespace :public do
    resources :conversations
  end

  resources :variants do
    member do
      delete :purge_image
    end
  end

  namespace :api do
    namespace :v1 do
      resources :assistants, only: [:show]
      post "auth/google_login", to: "auth#google_login"
    end
  end

  root "pages#home"
end
