# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  name            :string           not null
#  nickname        :string
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

  validates :name ,
    presence: true,
    uniqueness: true,
    length: {maximum: 16},
    format: {
      with: /\A[a-z0-9]+\z/, # //内に書く。\A,\zが始まりと終わり
      message: "小文字英数字で入力してください"
    }
  
  validates :password,
    uniqueness: true,
    length: { minimum: 6, maximum: 30} # minimumならpresenceいらん
  
  
  
end
