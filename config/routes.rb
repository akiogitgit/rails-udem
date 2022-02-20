Rails.application.routes.draw do
  get 'user/new'
  root "boards#index"

  get "boards", to: "boards#index"
  get "boards/new", to: "boards#new"
  post "boards", to: "boards#create"
end
