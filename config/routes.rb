Rails.application.routes.draw do
  get 'user/new'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  root "boards#index"
  get "boards", to: "boards#index"
  get "boards/new", to:"boards#new"
end
