require 'test_helper'

class UsersLoginTest < ActionDispatch::IntegrationTest

  def setup
    # users corresponds to fixture filename: users.yml
    # :john references user with the key in that file
    @user = users(:john)
  end

  test "logged in users should not see the login page" do
    get login_path
    assert_template "sessions/new"
    post login_path, params: { session: {email: @user.email, password: 'password' } }
    assert is_logged_in?
    get login_path
    assert_redirected_to twitter_users_url
  end

  test "login with invalid information" do
    get login_path
    assert_template "sessions/new"
    post login_path, params: { session: {email: "", password: "" } }
    assert_template "sessions/new"
    assert_not flash.empty?
    get root_path
    assert flash.empty?
  end

  test "login with valid information and then logut" do
    get login_path
    assert_template "sessions/new"
    post login_path, params: { session: {email: @user.email, password: 'password' } }
    assert is_logged_in?
    assert_redirected_to users_path
    follow_redirect!
    assert_template "users/index"
    assert_select "a[href=?]", login_path, count: 0
    assert_select "a[href=?]", logout_path
    assert_select "a[href=?]", add_user_path
    assert_select "a", "Watch List"
    assert_select "a", "Deleted Twits"
    delete logout_path
    assert_not is_logged_in?
    assert_redirected_to root_url
    follow_redirect!
    assert_select "a[href=?]", logout_path, count: 0
    assert_select "a[href=?]", add_user_path, count: 0
    assert_select "form input" do
      assert_select "[name=?]", "session[password]"
    end
  end

end
