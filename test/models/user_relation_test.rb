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
require "test_helper"

class UserRelationTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
