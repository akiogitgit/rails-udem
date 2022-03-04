# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  name            :string           not null
#  password_digest :string           not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
# Indexes
#
#  index_users_on_name  (name) UNIQUE
#
class User < ApplicationRecord
  # password, password_confirmation(確認用)の仮想的なカラムが追加される
  has_secure_password
  
  # controllerで使える。 active_relationships.find_by(followed_id: 1, ...)
  # フォローをする関係
  has_many :active_relationships,        # 今つけた名前
            class_name: "User_relation", # テーブルを参照
            foreign_key: "follower_id",  # このカラムを使う
            dependent: :destroy          # ユーザー消したら関連も消えるよ

  # フォローをされた関係
  has_many :passive_relationships,       # 今つけた名前
            class_name: "User_relation", # テーブルを参照
            foreign_key: "followed_id",  # このカラムを使う
            dependent: :destroy          # ユーザー消したら関連も消えるよ
  

  # 一覧画面で使用できるようにする
  has_many :followings,
            through: :active_relationships,
            source: :followed

  has_many :followings,
            through: :passive_relationships,
            source: :follower

  validates :name,
    presence: true,
    uniqueness: true,
    length: { maximum: 16 },
    format: {
      with: /\A[a-z0-9]+\z/, # //内に書く。\A,\zが始まりと終わり
      message: "は小文字英数字で入力してください"
    }
  
  validates :password,
    # uniqueness: true, これつけると、まさかのエラー
    length: { minimum: 6, maximum: 30} # minimumならpresenceいらん
end