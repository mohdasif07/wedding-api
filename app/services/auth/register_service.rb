module Auth
  class RegisterService
    def initialize(params)
      @params = params
    end

    def call
      user = User.new(user_attributes)
      user.role = :family_member unless user.admin?

      return failure(user.errors.full_messages) unless user.save

      tokens = issue_tokens(user)
      success(user, tokens)
    end

    private

    attr_reader :params

    def user_attributes
      params.slice(:first_name, :last_name, :email, :phone, :password, :password_confirmation)
    end

    def issue_tokens(user)
      Auth::TokenIssuer.new(user).call
    end

    def success(user, tokens)
      { success: true, user: user, tokens: tokens }
    end

    def failure(errors)
      { success: false, errors: errors }
    end
  end
end
