# == Route Map
#

Rails.application.routes.draw do
  root "boards#index" # login は home#index

  get "login", to: "home#index"
  post "login", to: "sessions#create"
  delete "logout", to: "sessions#destroy"

  get "followings", to: "user_relations#followings"
  get "followers", to: "user_relations#followers"

  resources :boards do
    resources :favorites, only: %i[create destroy]
  end
  resources :comments, only: %i[create destroy]
  resources :tags, only: %i[index create destroy]
  resources :users
  resources :user_relations, only: %i[create destroy]
end
