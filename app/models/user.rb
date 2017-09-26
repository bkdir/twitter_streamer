class User < ApplicationRecord
  attr_accessor :remember_token, :reset_token

  before_save { email.downcase! }

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 },
    format: { with: VALID_EMAIL_REGEX },
    uniqueness: { case_sensitive: false }
  validates :name, presence: true, length: { maximum: 30 },
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

  # creates a random string of length 22
  def User.new_token
    SecureRandom.urlsafe_base64
  end

  # to support persistent session
  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end

  def forget
    update_attribute(:remember_digest, nil)
  end
  
  # Returns true if the given token matches the digest.
  def authenticated?(attribute, token)
    digest = self.send("#{attribute}_digest")
    return false if digest.nil?
    BCrypt::Password.new(digest).is_password?(token)
  end
   
  def send_password_reset_email
		UserMailer.password_reset(self).deliver_now
  end 

  def create_reset_digest
    self.reset_token = User.new_token
		update_columns(reset_digest: User.digest(reset_token), 
                   reset_sent_at: Time.zone.now)
  end

  def password_reset_expired?
		self.reset_sent_at < 2.hours.ago
  end
end
