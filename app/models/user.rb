class User < ActiveRecord::Base
  has_secure_password

  validates :first_name, :last_name, presence: true
  validates :email, uniqueness: {case_sensitive: false}, format: {
    with: REGEXP[:email_validator],
    message: "Invalid email"
  }

  before_create :generate_verification_token
  after_commit :send_verification_mail, on: :create

  def verify!
    self.verified_at = Time.current
    self.verification_token = nil
    self.verification_token_expiry_at = nil
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

  def reset_password!(new_password)
    self.password = new_password
    self.forgot_password_token = nil
    self.forgot_password_token_expiry_at = nil
    save
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

  def reset_remember_me
    self.remember_me_token = nil
    save
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
        self[token_for_expiry_time] = Time.current + CONSTANTS["time_to_expiry"].hours
        if should_save
          save
        end
        break

      end
    end
  end

  def send_verification_mail
    UserNotifier.email_verification(self).deliver
  end

  def send_password_recovery_mail
    UserNotifier.password_reset(self).deliver
  end

end
