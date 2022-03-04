require "test_helper"

class UserRelationsControllerTest < ActionDispatch::IntegrationTest
  test "should get followings" do
    get user_relations_followings_url
    assert_response :success
  end

  test "should get followings" do
    get user_relations_followings_url
    assert_response :success
  end

  test "should get followers" do
    get user_relations_followers_url
    assert_response :success
  end
end
