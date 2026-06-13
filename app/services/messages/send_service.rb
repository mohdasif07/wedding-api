module Messages
  class SendService
    def initialize(user:, subject:, body:, guest_ids:, event: nil, message_type: :custom, channel: :email)
      @user = user
      @subject = subject
      @body = body
      @guest_ids = guest_ids
      @event = event
      @message_type = message_type.to_sym
      @channel = channel.to_sym
    end

    def call
      guests = Guest.where(id: guest_ids)
      return failure(["Select at least one guest"]) if guests.empty?

      message = user.messages.create!(
        event: event,
        subject: subject,
        body: body,
        message_type: message_type
      )

      sent = 0
      failed = 0
      errors = []

      guests.each do |guest|
        recipient = message.message_recipients.create!(guest: guest, channel: channel)

        if channel == :email
          if guest.email.blank?
            recipient.update!(status: :failed, error_message: "No email address")
            failed += 1
            errors << "#{guest.full_name}: no email"
            next
          end

          GuestMessageMailer.notify(guest, message).deliver_later
          recipient.update!(status: :sent, sent_at: Time.current)
          sent += 1
        else
          recipient.update!(status: :sent, sent_at: Time.current)
          sent += 1
        end
      end

      { success: true, message: message, sent: sent, failed: failed, errors: errors }
    end

    private

    attr_reader :user, :subject, :body, :guest_ids, :event, :message_type, :channel

    def failure(errors)
      { success: false, errors: errors }
    end
  end
end
