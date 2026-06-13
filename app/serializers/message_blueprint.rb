class MessageBlueprint < Blueprinter::Base
  identifier :id

  fields :subject, :body, :message_type, :event_id, :created_at

  field :recipients_count do |message|
    message.message_recipients.count
  end

  field :sent_count do |message|
    message.message_recipients.sent.count
  end

  view :detailed do
    association :message_recipients, blueprint: MessageRecipientBlueprint
  end
end
