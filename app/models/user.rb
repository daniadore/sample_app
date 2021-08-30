class User < ApplicationRecord
  attr_accessor :remember_token

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

  class << self
    def new_token
      SecureRandom.urlsafe_base64
    end

  # Returns the hash digest of the given string.
    def digest string
      cost = if ActiveModel::SecurePassword.min_cost
        BCrypt::Engine::MIN_COST
      else
        BCrypt::Engine.cost
      end
        BCrypt::Password.create string, cost: cost
    end
  end

  def remember
    self.remember_token = User.new_token
    update_attribute :remember_digest, User.digest(remember_token)
  end

  def authenticated? remember_token
    BCrypt::Password.new(remember_digest).is_password? remember_token
  end

  def forget
    update_attribute :remember_digest, nil
  end
end
