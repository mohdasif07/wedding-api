class RsvpBlueprint < Blueprinter::Base
  identifier :id

  fields :status, :guest_id, :event_id, :created_at
end
