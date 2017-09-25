class User < ApplicationRecord
  before_save { email.downcase! }
  validates :name, presence: true, length: { maximum: 30 },
    uniqueness: { case_sensitive: false }

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 },
    format: { with: VALID_EMAIL_REGEX },
    uniqueness: { case_sensitive: false }

  has_secure_password
  # allow_nil is to be able to edit the user w.o password.
  # has_secure_password will catch the nil pw while creating new users
  validates :password, presence: true, length: { minimum: 6 }, allow_nil: true

  # more cost means better encryption but on dev and test we just
  # need speed. This is how actually has_secure_password works
  # but we need it for testing and session purposes
  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : 
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end
end
