require 'test_helper'

class SessionsControllerTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:john)
  end

  test "should get login page with title Login" do
    get login_path
    assert_response :success
    assert_select "title", "Login"
  end

  test "should redirect to root after logut" do
    delete logout_path
    assert_response :redirect
    follow_redirect!
    assert_select "title", "Login"
  end

  test "should redirect to twitter users path if logged in" do
    login_test_user(@user)
    assert_redirected_to twitter_users_path
    follow_redirect!
    assert_select "title", "Twitter Users"
  end
end
