module Auth
  class PasswordResetRequestService
    def initialize(email:)
      @email = email
    end

    def call
      user = User.find_by(email: email.to_s.downcase.strip)
      return { success: true } unless user

      raw_token = SecureRandom.urlsafe_base64(32)
      digest = Digest::SHA256.hexdigest(raw_token)

      user.password_reset_tokens.create!(
        token_digest: digest,
        expires_at: 2.hours.from_now
      )

      PasswordResetMailer.reset_instructions(user, raw_token).deliver_later
      { success: true, reset_token: raw_token }
    end

    private

    attr_reader :email
  end
end
