class Comment < ApplicationRecord
  belongs_to :board
  validates :name, presence: true,length: {maximum: 20}
  validates :comment, presence: true,length: {maximum: 100}
end
