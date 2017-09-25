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

  test "email address should be unique and case insensitive" do
    dup_user = @user.dup
    dup_user.email = @user.email.upcase
    @user.save
    assert_not dup_user.valid?
  end

  test "name should not be too long" do
    @user.name = "a" * 31
    assert_not @user.valid?
  end

  test "email should not be too long" do
    @user.email = "a" * 244 + "@example.com"
    assert_not @user.valid?
  end
  
  test "email validation should accept valid email addresses" do
    valid_emails = %w[johndoe@example.com JohnDOE@example.COM TEST_U-ser@foo.bar.org 
                      name.lastname@test.jp john+doe@test.cn]
    valid_emails.each do |email|
      @user.email = email
      assert @user.valid?, "#{email.inspect} should be valid"
    end
  end

  test "email validation should reject invalid email addresses" do
    invalid_addresses = %w[user@example,com test_test.org 
                           user.name@example.email@test.com test@test+test.com]
    invalid_addresses.each do |email|
      @user.email = email
      assert_not @user.valid?, "#{email.inspect} should be invalid"
    end
  end
  
  test "email addresses should be saved as lower-case" do
    email = "TeST@exAMPLe.CoM"
    @user.email = email
    @user.save
    assert_equal email.downcase, @user.reload.email
  end
  
  test "password cannot be bland" do
    @user.password = @user.password_confirmation =  " " * 6
    assert_not @user.valid?
  end

  test "password should have a minmum length" do
    @user.password = @user.password_confirmation =  "a" * 5
    assert_not @user.valid?
  end

  test "A nonblank and length >= 6 password should be valid" do
    @user.password = @user.password_confirmation =  "a" * 6
    assert @user.valid?
  end

  test "authenticated? should return false for a user with nil digest" do
    assert_not @user.authenticated?('')
  end
end
