# frozen_string_literal: true

Rails.application.routes.draw do
  mount_devise_token_auth_for 'User', at: 'auth/v1/user'
  mount LetterOpenerWeb::Engine, at: "/letter_opener" if Rails.env.development?

  namespace :admin do
    namespace :v1 do
      get 'home' => 'home#index'
      resources :categories
      resources :system_requirements
      resources :coupons
      resources :users
      resources :products
    end
  end

  namespace :storefront do
    namespace :v1 do
    end
  end
end
