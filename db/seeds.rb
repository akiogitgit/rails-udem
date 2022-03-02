# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

# bundle exec rails db:seed で実行
if Rails.env == "development"

  # 投稿作成
  (1..50).each do |i|
    Board.create(name: "ユーザー#{i}", title: "タイトル#{i}", body: "本文#{i}")
  end

  #タグ作成
  (1..10).each do |i|
    Tag.create(name: "タグ#{i}")
  end
end