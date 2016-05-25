class User < ActiveRecord::Base
  has_secure_password

  validates :first_name, :last_name, presence: true
  #FIXME_AB: whenever use uniqueness check for case sensitivity akhil AKHIL shold be same
  validates :email, uniqueness: true, format: {
    with: REGEXP[:email_validator],
    message: "Invalid email"
  }


  before_create :generate_verification_token
  after_commit :send_verification_mail, on: :create

  #FIXME_AB: verify!
  def verify
    self.verified_at = Time.current
    self.verification_token = nil
    self.verification_token_expiry_at = nil
    save
  end

  #FIXME_AB: rename valid_verification_token?
  def check_token_expiry
    verification_token_expiry_at > Time.current
  end

  def verified?
    verified_at.present?
  end

  protected

  def generate_verification_token
    loop do
      random_token = SecureRandom.hex
      if !(User.exists?(verification_token: random_token))
        self.verification_token = random_token
        self.verification_token_expiry_at = Time.current + TIME_TO_EXPIRY.hours
        break
      end
    end
  end

  def generate_forgot_password_token

    loop do
      random_token = SecureRandom.hex
      if !(User.exists?(forgot_password_token: random_token))
        self.forgot_password_token = random_token
        self.forgot_password_token_expiry_at = Time.current + TIME_TO_EXPIRY.hours
        break
      end
    end
  end

  def send_verification_mail
    #FIXME_AB: user_verification to email_verification
    UserNotifier.user_verification(self).deliver
  end

end
