# == Schema Information
#
# Table name: favorites
#
#  id         :integer          not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  board_id   :integer
#  user_id    :integer
#
class Favorite < ApplicationRecord
  belongs_to :user
  belongs_to :board
end
