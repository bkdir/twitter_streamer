require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:john)
    login_test_user(@user)
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
    assert_select 'div.error_explanation'
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
