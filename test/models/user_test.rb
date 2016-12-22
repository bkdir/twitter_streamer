require 'test_helper'

class UserTest < ActiveSupport::TestCase
  
  def setup
    @user = User.new(name: "John Doe", email: "johndoe@example.com",
                    password: "test12", password_confirmation: "test12")
  end

  test "User should be valid" do
    assert @user.valid?
  end

  test "name should be present" do
    @user.name = ""
    assert_not @user.valid?
  end

  test "email should be present" do
    @user.email = " "
    assert_not @user.valid?
  end

  test "email address should be unique" do
    dup_user = @user.dup
    @user.save
    assert_not dup_user.valid?
  end
  
  test "email validation should accept valid email addresses" do
    valid_emails = %w[ johndoe@example.com JohnDOE@example.COM TEST_U-ser@foo.bar.org name.lastname@test.jp john+doe@test.cn ]
    valid_emails.each do |email|
      @user.email = email
      assert @user.valid?, "#{email.inspect} should be valid"
    end
  end

  test "email validation should reject invalid email addresses" do
    invalid_addresses = %w[ user@example,com test_test.org user.name@example.email@test.com test@test+test.com ]
    invalid_addresses.each do |email|
      @user.email = email
      assert_not @user.valid?, "#{email.inspect} should be invalid"
    end
  end

end
