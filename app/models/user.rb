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

  # attachment :profile_image # user_imageの設定
  mount_uploader :image, ImageUploader
  
  # controllerで使える。 active_relationships.find_by(followed_id: 1, ...)
  # フォローをする関係
  has_many :active_relationships,        # 今つけた名前
            class_name: "UserRelation", # テーブルを参照
            foreign_key: "follower_id",  # このカラムを使う
            dependent: :destroy          # ユーザー消したら関連も消えるよ

  # フォロワーの関係
  has_many :passive_relationships,       # 今つけた名前
            class_name: "UserRelation", # テーブルを参照
            foreign_key: "followed_id",  # このカラムを使う
            dependent: :destroy          # ユーザー消したら関連も消えるよ
  

  # 一覧画面で使用できるようにする user.followers で使える
  has_many :followings,
            through: :active_relationships,
            source: :followed # followingsはfollowed idの集合体

  has_many :followers,
            through: :passive_relationships,
            source: :follower  # followingsはfollower idの集合体
  
  # こっちは　いいねの方
  has_many :favorites, dependent: :delete_all

  # 上の記述により使えるメソッド
  # active_relationships.follower フォロワーを返す
  # active_relationships.followed　フォローしてるユーザーを返す
  # user.active_relationships.create(followed_id: user_id)　登録する
  # user.following.include?(user)
  # user.following.find(user)

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


  # フォローする
  def follow(user_id)
    active_relationships.create(followed_id: user_id)
  end

  # フォロー解除
  def unfollow(user_id)
    active_relationships.find_by(followed_id: user_id).destroy
  end

  # 現在のユーザーがフォローしてるか
  def following?(user)
    followings.include?(user)
  end
end