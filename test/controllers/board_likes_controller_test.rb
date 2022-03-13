require "test_helper"

class BoardLikesControllerTest < ActionDispatch::IntegrationTest
  test "should get update" do
    get board_likes_update_url
    assert_response :success
  end
end
