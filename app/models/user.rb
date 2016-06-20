# == Schema Information
#
# Table name: users
#
#  id                              :integer          not null, primary key
#  first_name                      :string(255)      not null
#  last_name                       :string(255)      not null
#  email                           :string(255)      not null
#  password_digest                 :string(255)      not null
#  admin                           :boolean          default(FALSE)
#  verification_token              :string(255)
#  verification_token_expiry_at    :datetime
#  verified_at                     :datetime
#  forgot_password_token           :string(255)
#  forgot_password_token_expiry_at :datetime
#  remember_me_token               :string(255)
#  created_at                      :datetime         not null
#  updated_at                      :datetime         not null
#  credit_balance                  :float(24)        default(0.0), not null
#  lock_version                    :integer
#
# Indexes
#
#  index_users_on_forgot_password_token  (forgot_password_token)
#  index_users_on_remember_me_token      (remember_me_token)
#  index_users_on_verification_token     (verification_token)
#

class User < ActiveRecord::Base

  attr_accessor :validate_password

  has_secure_password

  validates :first_name, :last_name, presence: true
  validates :email, uniqueness: {case_sensitive: false}, format: {
    with: REGEXP[:email_validator],
    message: "Invalid email"
  }

  validates :password, length: {minimum: 6}, if: "validate_password.present?"

  has_many :credit_transactions, dependent: :destroy
  has_many :questions, dependent: :nullify
  has_many :answers, dependent: :nullify, inverse_of: :user
  has_many :transactions, dependent: :restrict_with_error
  has_many :orders, dependent: :restrict_with_error
  has_many :comments, dependent: :nullify, inverse_of: :user
  has_many :abuse_reports, dependent: :destroy
  has_many :follows, class_name: "Relationship", foreign_key: "follower_id"
  has_many :followed_by, class_name: "Relationship", foreign_key: "followed_id"

  scope :verified, -> {where.not(verified_at: nil)}

  before_create :generate_verification_token, if: "!admin?"
  before_create :auto_verify_email, if: "admin?"
  before_validation :set_validate_password, on: :create
  after_commit :send_verification_mail, on: :create

  def verify!
    self.transaction do
      credit_transactions.signup.create!(points: CONSTANTS["initial_credit_points"], resource_id: id,resource_type: self.class)
      self.verified_at = Time.current
      self.verification_token = nil
      self.verification_token_expiry_at = nil
      save
    end
  end

  def change_password!(new_password, confirm_password)
    self.validate_password = true
    self.password = new_password
    self.password_confirmation = confirm_password
    self.forgot_password_token = nil
    self.forgot_password_token_expiry_at = nil
    save
  end

  def valid_verification_token?
    verification_token_expiry_at > Time.current
  end

  def valid_forgot_password_token?
    forgot_password_token_expiry_at > Time.current
  end

  def verified?
    verified_at.present?
  end

  def send_forgot_password_instructions
    generate_forgot_password_token
    send_password_recovery_mail
  end

  def generate_remember_me_token
    loop do
      random_token = SecureRandom.hex
      if !(User.exists?(remember_me_token: random_token))
        self.remember_me_token = random_token
        save
        break
      end
    end
  end

  def reset_remember_me!
    self.remember_me_token = nil
    save
  end

  def following?(other_user)
    follows.find_by(followed_id: other_user.id)
  end

  protected

  def generate_verification_token
    generate_token(:verification_token, :verification_token_expiry_at, false)
  end

  def generate_forgot_password_token
    generate_token(:forgot_password_token, :forgot_password_token_expiry_at, true)
  end

  def generate_token(token_for, token_for_expiry_time, should_save)

    loop do
      random_token = SecureRandom.hex
      if !(User.exists?(token_for => random_token))
        self[token_for] = random_token
        self[token_for_expiry_time] = CONSTANTS["time_to_expiry"].hours.from_now
        if should_save
          save
        end
        break
      end
    end
  end

  def send_verification_mail
    UserNotifier.email_verification(self).deliver unless admin?
  end

  def send_password_recovery_mail
    UserNotifier.password_reset(self).deliver
  end

  def set_validate_password
    self.validate_password = true
  end

  def auto_verify_email
    self.verified_at = Time.current
  end

end
