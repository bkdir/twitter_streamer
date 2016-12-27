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
    login_test_user(@other_user)
    get twitter_users_show_url
    assert_response :success
  end

end
