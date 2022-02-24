class Board < ApplicationRecord
  # validates :name, presence: true, uniqueness: { case_sensitive: false }, length: {maximum: 50}, format: { with: ConstantData::VALID_EMAIL_REGEX }, if: :method_name?
  
  #                必須　　　　　　　文字数
  validates :name, presence: true, length: {maximum: 20}
  validates :title, presence: true, length: {maximum: 30}
  validates :body, presence: true, length: {maximum: 500}
end
