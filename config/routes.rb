Rails.application.routes.draw do
  get 'user/new'

  root "boards#index"
  get "boards", to: "boards#index" # 一覧
  get "boards/new", to: "boards#new" # 新規作成
  post "boards", to: "boards#create" # form送信
  get "boards/:id", to: "boards#show" # 個別ページ
end
