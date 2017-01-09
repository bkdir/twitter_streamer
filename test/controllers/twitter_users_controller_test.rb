require 'test_helper'

class TwitterUsersControllerTest < ActionDispatch::IntegrationTest
  def setup
    @other_user = users(:jane)
  end

  test "logged in users should get index" do
    login_test_user(@other_user)
    get twitter_users_url
    assert_response :success
  end

  test "logged in users should get show" do
    skip "not really true, should not be able to get show page if user cannot be found for any reason"
    login_test_user(@other_user)
    get twitter_user_url(@other_user)
    assert_response :success
  end

end
