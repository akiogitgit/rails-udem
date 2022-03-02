# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  birthday        :date
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
  
  def age
    now = Time.zone.now # 時間を取得
    # 現在の日付から誕生日を引いて、年だけを取得
    (now.strftime("%Y%m%d").to_i - birthday.strftime("%Y%m%d").to_i) / 10000
  end
end