class GuestInvitationMailer < ApplicationMailer
  def invite(guest, message)
    @guest = guest
    @event = guest.event
    @message = message

    mail(to: guest.email, subject: message.subject)
  end
end
