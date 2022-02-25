# == Route Map
#

Rails.application.routes.draw do
  root "boards#index"

  # get "boards", to: "boards#index" # 一覧
  # get "boards/new", to: "boards#new" # 新規作成
  # post "boards", to: "boards#create" # form送信
  # get "boards/:id", to: "boards#show" # 個別ページ
  resources :boards # これで上の全てに対応
  resources :comments, only: %i[create destroy]

  #                        一覧      新規作成 POST  動的    更新    POST
  # resources :boards, only: [:index, :new, :create, :show, :edit, :update, :destroy] # これだけ使用する場合

end
