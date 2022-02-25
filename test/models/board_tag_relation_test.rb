# == Schema Information
#
# Table name: board_tag_relations
#
#  id         :integer          not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  board_id   :integer          not null
#  tag_id     :integer          not null
#
# Indexes
#
#  index_board_tag_relations_on_board_id  (board_id)
#  index_board_tag_relations_on_tag_id    (tag_id)
#
# Foreign Keys
#
#  board_id  (board_id => boards.id)
#  tag_id    (tag_id => tags.id)
#
require "test_helper"

class BoardTagRelationTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
