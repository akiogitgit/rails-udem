# == Schema Information
#
# Table name: boards
#
#  id         :integer          not null, primary key
#  body       :text
#  name       :string
#  published  :boolean          default(TRUE)
#  title      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Board < ApplicationRecord
  # commentは一体多, tagsは多対多, board_tag_relationは、中間テーブル
  # dependentは、関連しているものが削除された時に消す

  has_many :comments, dependent: :delete_all
  has_many :board_tag_relations, dependent: :delete_all
  has_many :tags, through: :board_tag_relations
  has_many :favorites, dependent: :delete_all

  validates :name, presence: true, length: {maximum: 20}
  validates :title, presence: true, length: {maximum: 30}
  validates :body, presence: true, length: {maximum: 500}

  # いいねを確認
  def favorited_by?(user)
    favorites.where(user_id: user.id).exists?
  end
end
