class Board < ApplicationRecord
  has_many :comments
  #                必須　　　　　　　文字数
  validates :name, presence: true, length: {maximum: 20}
  validates :title, presence: true, length: {maximum: 30}
  validates :body, presence: true, length: {maximum: 500}
end
