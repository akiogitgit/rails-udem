# == Schema Information
#
# Table name: tags
#
#  id         :integer          not null, primary key
#  name       :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Tag < ApplicationRecord
  has_many :board_tag_relations, dependent: :delete_all
  has_many :boards, through: :board_tag_relations

  validates :name, presence: true, uniqueness: true, length: {maximum: 10}
end
