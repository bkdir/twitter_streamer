require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:john)
    @other_user = users(:jane)
  end

  test "Logged in user should get new" do
    login_test_user(@user)
    get new_user_url
    assert_response :success
  end

  test "non-logged in users should be redirected to login page on edit" do
    get edit_user_path(@user)
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  test "should redirect index page when not logged in" do
    get users_path
    assert_redirected_to login_url
  end

  test "non-logged in users should be redirected to login page on update" do
    patch user_path(@user), params: {
      user: {
        name: @user.name,
        email: @user.email
      }
    }
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  test "users should only be able to edit their own information" do
    login_test_user(@other_user)
    get edit_user_path(@user)
    assert flash.empty?
    assert_redirected_to users_path
  end

  test "users should be redirected if they update someone else's information" do
    login_test_user(@other_user)
    patch user_path(@user), params: {
      user: {
        name: @user.name,
        email: @user.email
      }
    }
    assert flash.empty?
    assert_redirected_to users_path
  end

  test "admin attribute should not be editable via we" do
    login_test_user(@other_user)
    assert_not @other_user.admin?
    patch user_path(@other_user), params: {
      user: {
        password: 'password',
        password_confirmation: 'password',
        admin: 1
      }
    }

    assert_not @other_user.reload.admin?
  end

  test "should redirect destroy when not logged in" do 
    assert_no_difference 'User.count' do
      delete user_path(@user)
    end
    assert_redirected_to login_url
  end

  test "should redirect destroy when logged in as a non-admin" do 
    login_test_user(@other_user)
    assert_no_difference 'User.count' do
      delete user_path(@user)
    end
    assert_redirected_to users_url
  end

  test "admin should be able to destroy a user" do 
    login_test_user(@user)
    assert_difference 'User.count', -1 do
      delete user_path(@other_user)
    end
    assert_redirected_to users_url
  end

end
