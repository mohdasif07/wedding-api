class MessageRecipient < ApplicationRecord
  belongs_to :message
  belongs_to :guest

  enum :channel, { email: 0, whatsapp: 1, sms: 2 }
  enum :status, { pending: 0, sent: 1, failed: 2 }

  validates :guest_id, uniqueness: { scope: :message_id }
end
