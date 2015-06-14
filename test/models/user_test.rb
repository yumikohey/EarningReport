require 'test_helper'

class UserTest < ActiveSupport::TestCase
  def setup
  	@user = User.new(name: "Example User", email: "user@example.com", 
                     password: "foobar", password_confirmation: "foobar")
  end

  test "should be valid" do
  	assert @user.valid?
  end

  test "name should be present" do
  	@user.name = "    "
  	assert_not @user.valid?
  end

  test "email should be present" do
  	@user.email = "    "
  	assert_not @user.valid?
  end

  test "name should not be too long" do
  	@user.name = "a" * 51
  	assert_not @user.valid?
  end

  test "email validation should accept valid address" do
  	valid_addresses = %w[user@example.com USER@foo.com A_US-ER@foo.bar.org
  											 first.last@foo.jp alice+bob@baz.cn]
  	valid_addresses.each do |valid_address|
  		@user.email = valid_address
  		assert @user.valid?, "Address #{valid_address} should be valid"
  	end
  end

  test "email validation should reject invalid addresses" do
  	invalid_addresses = %w[user@example,com user_at_foo.org user.name@example_bax.com]
  	invalid_addresses.each do |invalid_address|
  		@user.email = invalid_address
  		assert @user.valid?
  	end
  end

  test "email address should be unique" do
  	duplicate_user = @user.dup
  	@user.save
  	assert_not duplicate_user.valid?
  end

  test "password should have a min length" do
    @user.password = "a" * 5
    @user.password_confirmation = "a" * 5
    assert_not @user.valid?
  end

  test "authenticated? should return false for a user with a nil digest" do
    assert_not @user.authenticated?('')
  end
end
