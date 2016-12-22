require 'test_helper'

class SessionsControllerTest < ActionDispatch::IntegrationTest
  test "should get login page with title Login" do
    get login_path
    assert_response :success
    assert_select "title", "Login"
  end
end
