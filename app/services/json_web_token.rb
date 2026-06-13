class JsonWebToken
  SECRET = ENV.fetch("JWT_SECRET_KEY") { Rails.application.secret_key_base }
  ACCESS_EXPIRY = ENV.fetch("JWT_ACCESS_TOKEN_EXPIRY", 3600).to_i
  REFRESH_EXPIRY = ENV.fetch("JWT_REFRESH_TOKEN_EXPIRY", 604_800).to_i

  class << self
    def encode(payload, exp: ACCESS_EXPIRY)
      payload = payload.dup
      payload[:exp] = Time.current.to_i + exp
      JWT.encode(payload, SECRET, "HS256")
    end

    def decode(token)
      body = JWT.decode(token, SECRET, true, algorithm: "HS256")[0]
      HashWithIndifferentAccess.new(body)
    rescue JWT::DecodeError
      nil
    end

    def access_token_for(user)
      encode({ user_id: user.id, type: "access" })
    end

    def refresh_token_for(user)
      encode({ user_id: user.id, type: "refresh" }, exp: REFRESH_EXPIRY)
    end
  end
end
