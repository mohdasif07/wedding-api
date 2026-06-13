class PasswordResetMailer < ApplicationMailer
  def reset_instructions(user, token)
    @user = user
    @reset_url = "#{ENV.fetch('APP_URL', 'http://localhost:3000')}/reset-password?token=#{token}"

    mail(to: user.email, subject: "Password Reset Instructions")
  end
end
