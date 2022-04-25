# == Schema Information
#
# Table name: user_relations
#
#  id          :integer          not null, primary key
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  followed_id :integer
#  follower_id :integer
#
class UserRelation < ApplicationRecord
  # User同士のリレーションだから、特殊 class_nameで、そのテーブルから参照してる
  belongs_to :follower, class_name: "User"
  belongs_to :followed, class_name: "User"
end
