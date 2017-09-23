require 'test_helper'

class UsersIndexTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:john) # Admin
    @other_user = users(:jane)
  end

  test "index includes pagination" do
    login_test_user(@user)
    get users_path
    assert_template 'users/index'
    assert_select 'div.pagination'
    User.paginate(page: 1).each do |user|
      assert_select 'a' do |el|
        el.text == user.name
      end
    end
  end

  test "index page as an admin user should display destroy links for other users" do
    login_test_user(@user)
    get users_path
    assert_template 'users/index'
    assert_select 'div.pagination'
    users = User.order(updated_at: :desc).paginate(page: 1, per_page: 30)
    users.each do |user|
      unless user == @user
        assert_select 'a[href=?]', user_path(user)
      end
    end
  end

  test "index page as a non-admin user should not display delete links" do
    login_test_user(@other_user)
    get users_path
    assert_select 'a', text: 'delete', count: 0
  end
end
