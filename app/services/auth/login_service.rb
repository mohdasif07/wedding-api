module Auth
  class LoginService
    def initialize(email:, password:)
      @email = email
      @password = password
    end

    def call
      user = User.find_by(email: email.to_s.downcase.strip)
      return failure(["Invalid email or password"]) unless user&.authenticate(password)

      tokens = Auth::TokenIssuer.new(user).call
      success(user, tokens)
    end

    private

    attr_reader :email, :password

    def success(user, tokens)
      { success: true, user: user, tokens: tokens }
    end

    def failure(errors)
      { success: false, errors: errors }
    end
  end
end
