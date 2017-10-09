require 'test_helper'

class TwitterUserTest < ActiveSupport::TestCase
	def setup
    @user = TwitterUser.new(user_id: 1234, name: "jd", screen_name: "John Doe")
	end

  test "User with id, name and screen_name is valid" do
    assert @user.valid?
  end
end
