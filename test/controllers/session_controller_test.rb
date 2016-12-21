require 'test_helper'

class SessionControllerTest < ActionDispatch::IntegrationTest
  test "should get login page" do
    get root_url
    assert_response :success
    assert_select "title", "Login"
  end
end
