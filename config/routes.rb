# == Route Map
#

Rails.application.routes.draw do
  root "home#index" # login は home#indexでしてる

  # to でpath名を変えられる
  post "login", to: "sessions#create" # 当然post,deleteとかも使える
  delete "logout", to: "sessions#destroy"

  get "followings", to: "user_relations#followings"
  get "followers", to: "user_relations#followers"
  #     パス名省略　　　アクション  ->boards_path, boards_new_pathで使える
  # get "boards", to: "boards#index" # 一覧
  # get "boards/new", to: "boards#new" # 新規作成
  # post "boards", to: "boards#create" # form送信
  # get "boards/:id", to: "boards#show" # 個別ページ

  # resources は名前が固定されるが、一気にCRUDに必要なpathを生成
  resources :boards # これで上の全てに対応
  resources :comments, only: %i[create destroy] # onlyでこれだけ使う
  resources :tags, only: %i[index create destroy]
  resources :users
  # resources :sessions, only: %i[create destroy] # 名前を変えたいから上に書く
  resources :user_relations, only: %i[create destroy]
  resources :boards do
    resources :favorites, only: %i[create destroy]
  end
end
