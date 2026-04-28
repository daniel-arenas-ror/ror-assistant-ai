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
  resources :company, only: [:edit, :update]
  resources :users
  resources :leads
  resources :orders
  resources :conversations
  resources :option_types do
    collection do
      get :add_value
    end
  end

  resources :page_layouts
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

  resources :webhooks, only: [] do
    collection do
      post :stripe, to: "webhook/stripe#receive"
    end
  end

  namespace :api do
    namespace :v1 do
      resources :assistants, only: [:show]
      post "auth/google_login", to: "auth#google_login"
      post "auth/request_otp", to: "auth#request_otp"
      post "auth/verify_otp", to: "auth#verify_otp"
    end
  end

  root "pages#home"
end
