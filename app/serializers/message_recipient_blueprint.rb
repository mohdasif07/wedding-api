class MessageRecipientBlueprint < Blueprinter::Base
  identifier :id

  fields :channel, :status, :sent_at, :error_message, :guest_id

  field :guest_name do |recipient|
    recipient.guest.full_name
  end
end
