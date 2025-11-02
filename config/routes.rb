Rails.application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  devise_for :users
  get "up" => "rails/health#show", as: :rails_health_check

  resources :quotes do
    resources :line_item_dates, except: [:index, :show]
  end

  resources :company
  resources :users
  resources :real_estates

  root "pages#home"
end
