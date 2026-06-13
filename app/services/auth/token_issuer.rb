module Auth
  class TokenIssuer
    def initialize(user)
      @user = user
    end

    def call
      refresh_token = JsonWebToken.refresh_token_for(user)
      digest = Digest::SHA256.hexdigest(refresh_token)

      user.refresh_tokens.create!(
        token_digest: digest,
        expires_at: Time.current + JsonWebToken::REFRESH_EXPIRY.seconds
      )

      {
        access_token: JsonWebToken.access_token_for(user),
        refresh_token: refresh_token,
        token_type: "Bearer",
        expires_in: JsonWebToken::ACCESS_EXPIRY
      }
    end

    private

    attr_reader :user
  end
end
