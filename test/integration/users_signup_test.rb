require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:john)
    # first, login
    get login_path
    assert_template "sessions/new"
    post login_path, params: { session: {name: @user.name, password: 'password' } }
  end

  test "Sould not save user upon invalid signup submission" do
    get add_user_path
    assert_no_difference "User.count" do
      post users_path, params: {
        user: { 
            name: "", 
            email: "text.example.com", 
            password: "foo", 
            password_confirmation: "foo" 
        } 
      }
    end
    assert_template "users/new"
  end

  test "Sould save user upon valid signup submission" do
    get add_user_path
    assert_difference "User.count", 1 do
      post users_path, params: {
        user: { 
            name: "John Doe", 
            email: "johndoe@example.com", 
            password: "foo123", 
            password_confirmation: "foo123" 
        } 
      }
    end
    follow_redirect!
    assert_template "users/index"
  end

end
