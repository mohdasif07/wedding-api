module Invitations
  class SendService
    def initialize(guest:, user:, channel: :email)
      @guest = guest
      @user = user
      @channel = channel.to_sym
    end

    def call
      return failure(["Guest email is required for email invitation"]) if channel == :email && guest.email.blank?

      message = user.messages.create!(
        event: guest.event,
        subject: "Invitation: #{guest.event.title}",
        body: guest.invitation_text,
        message_type: :invitation
      )

      recipient = message.message_recipients.create!(guest: guest, channel: channel)

      if channel == :email
        GuestInvitationMailer.invite(guest, message).deliver_later
        recipient.update!(status: :sent, sent_at: Time.current)
      else
        recipient.update!(status: :sent, sent_at: Time.current)
      end

      guest.update!(invited_at: Time.current, invite_count: guest.invite_count + 1)

      success(message, recipient)
    rescue StandardError => e
      recipient&.update(status: :failed, error_message: e.message)
      failure([e.message])
    end

    private

    attr_reader :guest, :user, :channel

    def success(message, recipient)
      { success: true, message: message, recipient: recipient }
    end

    def failure(errors)
      { success: false, errors: errors }
    end
  end
end
