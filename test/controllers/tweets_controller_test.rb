require 'test_helper'

class TweetsControllerTest < ActionDispatch::IntegrationTest

  def setup
    @other_user = users(:jane)
  end

  test "logged in users should get index" do
    login_test_user(@other_user)
    get deleted_tweets_url
    assert_response :success
  end
end
