require 'test_helper'

class UserEditTest < ActionDispatch::IntegrationTest
	def setup
    @user = users(:john)
  end

  test "unsuccessful edit should re-render edit page" do
    login_test_user(@user)
    get edit_user_path(@user)
    assert_template 'users/edit'
    patch user_path(@user), params: { 
			user: { 
		  	name:  "",
				email: "test@test",
				password: "foo",
				password_confirmation: "bar" 
      } 
    }

    assert_template 'users/edit'
  end

  test "Successful edit" do
    login_test_user(@user)
    get edit_user_path(@user)
    assert_template 'users/edit'
    name = "Jane"
    email = "test@example.com"
    patch user_path(@user), params: {
      user: {
        name: name,
        email: email,
        password: 'password',
        password_confirmation: 'password'
      }
    }
    assert_not flash.empty?
    assert_redirected_to users_path
    @user.reload
    # FIXME
    assert_equal name, @user.name
    assert_equal email, @user.email
  end

  test "should friendly forward" do
    get edit_user_path(@user)
    login_test_user(@user)
    assert_redirected_to edit_user_url(@user)
  end
end
