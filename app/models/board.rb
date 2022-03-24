# == Schema Information
#
# Table name: boards
#
#  id         :integer          not null, primary key
#  body       :text
#  name       :string
#  private    :boolean          default(TRUE)
#  title      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Board < ApplicationRecord
  # commentは一体多, tagsは多対多, board_tag_relationは、中間テーブル
  # dependentの

  has_many :comments, dependent: :delete_all
  has_many :board_tag_relations, dependent: :delete_all
  has_many :tags, through: :board_tag_relations
  has_many :favorites, dependent: :delete_all

  #                必須　　　　　　　文字数
  validates :name, presence: true, length: {maximum: 20}
  validates :title, presence: true, length: {maximum: 30}
  validates :body, presence: true, length: {maximum: 500}

  # いいねを確認(書くのは、user.rbでもいける(favorited_by?(board))) @board.favorited_by?(@current_user)
  def favorited_by?(user)
    favorites.where(user_id: user.id).exists?
  end
end
