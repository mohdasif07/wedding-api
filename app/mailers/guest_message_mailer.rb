class GuestMessageMailer < ApplicationMailer
  def notify(guest, message)
    @guest = guest
    @message = message

    mail(to: guest.email, subject: message.subject)
  end
end
