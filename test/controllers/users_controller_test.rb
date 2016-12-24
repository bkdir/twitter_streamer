require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:john)
    # first, login
    get login_path
    assert_template "sessions/new"
    post login_path, params: { session: {name: @user.name, password: 'password' } }
  end

  test "Logged in user should get new" do
    get new_user_url
    assert_response :success
  end

end
