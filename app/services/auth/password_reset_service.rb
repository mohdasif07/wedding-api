module Auth
  class PasswordResetService
    def initialize(token:, password:, password_confirmation:)
      @token = token
      @password = password
      @password_confirmation = password_confirmation
    end

    def call
      digest = Digest::SHA256.hexdigest(token)
      reset_record = PasswordResetToken.active.find_by(token_digest: digest)
      return failure(["Invalid or expired reset token"]) unless reset_record

      user = reset_record.user
      user.password = password
      user.password_confirmation = password_confirmation

      return failure(user.errors.full_messages) unless user.save

      reset_record.mark_used!
      user.refresh_tokens.update_all(revoked_at: Time.current)
      success
    end

    private

    attr_reader :token, :password, :password_confirmation

    def success
      { success: true }
    end

    def failure(errors)
      { success: false, errors: errors }
    end
  end
end
