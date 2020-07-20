class User < ApplicationRecord
  USER_PARAMS = Settings.user_params.freeze
  attr_accessor :remember_token, :activation_token, :reset_token

  has_many :microposts, dependent: :destroy

  validates :name, presence: true,
  length: {maximum: Settings.user.name.max_length}
 validates :email, presence: true,
   length: {maximum: Settings.user.email.max_length},
   format: {with: Settings.user.email.valid_email_regex},
   uniqueness: true
 validates :password, presence: true,
   length: {minimum: Settings.user.password.min_length}, allow_nil: true

  before_create :create_activation_digest
  before_save :downcase_email

  class << self
    def digest string
      cost = if ActiveModel::SecurePassword.min_cost
               BCrypt::Engine::MIN_COST
             else
               BCrypt::Engine.cost
             end
      BCrypt::Password.create string, cost: cost
    end

    def new_token
      SecureRandom.urlsafe_base64
    end
  end

  def feed
    microposts
  end

  def activate
    update activated: true, activated_at: Time.zone.now
  end

  def send_activation_email
    UserMailer.account_activation(self).deliver_now
  end

  def create_reset_digest
    self.reset_token = User.new_token
    update_attributes reset_digest: User.digest(reset_token), reset_sent_at: Time.zone.now
  end

  def send_password_reset_email
    UserMailer.password_reset(self).deliver_now
  end

  def password_reset_expired?
    reset_sent_at < Settings.time_expired.hours.ago
  end

  has_secure_password

  def remember
    remember_token = User.new_token
    update_attribute :remember_digest, User.digest(remember_token)
  end

  def authenticated? attribute, token
    digest = send "#{attribute}_digest"
    return false unless digest

    BCrypt::Password.new(digest).is_password? token
  end

  def forget
    update_attribute :remember_digest, nil
  end

  private

  def downcase_email
    email.downcase!
  end

  def create_activation_digest
    self.activation_token = User.new_token
    self.activation_digest = User.digest activation_token
  end
end
