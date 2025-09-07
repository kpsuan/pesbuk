require "test_helper"

class FollowsControllerTest < ActionDispatch::IntegrationTest
  test "should get destroy" do
    get follows_destroy_url
    assert_response :success
  end
end
