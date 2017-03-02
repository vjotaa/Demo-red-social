require 'sidekiq/web'

Rails.application.routes.draw do

  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  resources :notifications, only: [:index,:update]
  resources :posts
  resources :accounts, as: :users, only: [:show, :update]
  resources :friendships, only: [:create,:update,:index]
  devise_for :users, controllers: {omniauth_callbacks: "users/omniauth_callbacks"}
  get 'main/home'
  authenticated :user do
  	root 'main#home'
  end

  unauthenticated :user do
  	root 'main#unregistered'
  end



  post "/custom_sign_up", to: "users/omniauth_callbacks#custom_sign_up"
  mount ActionCable.server => '/cable'
  mount Sidekiq::Web => '/sidekiq'
end
