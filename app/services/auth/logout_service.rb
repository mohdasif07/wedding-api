module Auth
  class LogoutService
    def initialize(user:, refresh_token: nil)
      @user = user
      @refresh_token = refresh_token
    end

    def call
      revoke_refresh_token if refresh_token.present?
      { success: true }
    end

    private

    attr_reader :user, :refresh_token

    def revoke_refresh_token
      digest = Digest::SHA256.hexdigest(refresh_token)
      token = user.refresh_tokens.active.find_by(token_digest: digest)
      token&.revoke!
    end
  end
end
