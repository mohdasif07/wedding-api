module Auth
  class RefreshTokenService
    def initialize(refresh_token:)
      @refresh_token = refresh_token
    end

    def call
      payload = JsonWebToken.decode(refresh_token)
      return failure(["Invalid refresh token"]) unless payload&.dig(:type) == "refresh"

      user = User.find_by(id: payload[:user_id])
      return failure(["User not found"]) unless user

      digest = Digest::SHA256.hexdigest(refresh_token)
      stored = user.refresh_tokens.active.find_by(token_digest: digest)
      return failure(["Refresh token revoked or expired"]) unless stored

      stored.revoke!
      tokens = Auth::TokenIssuer.new(user).call
      success(user, tokens)
    end

    private

    attr_reader :refresh_token

    def success(user, tokens)
      { success: true, user: user, tokens: tokens }
    end

    def failure(errors)
      { success: false, errors: errors }
    end
  end
end
