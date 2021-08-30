class User < ApplicationRecord

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  #validates name
  validates :name, presence: true
  #validates email
  validates :email, presence: true, length: {maximum: 255}, format: {with: VALID_EMAIL_REGEX}
  has_secure_password

  #email lowercase  conversion
  before_save :downcase_email

  private

  def downcase_email
    self.email.downcase!
  end

  # Returns the hash digest of the given string.
  def User.digest string
    cost = if ActiveModel::SecurePassword.min_cost
      BCrypt::Engine::MIN_COST
    else
      BCrypt::Engine.cost
    end
      BCrypt::Password.create string, cost: cost
  end
end
