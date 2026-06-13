class GuestBlueprint < Blueprinter::Base
  identifier :id

  fields :first_name, :last_name, :phone, :email, :family_name, :side,
         :rsvp_status, :address, :qr_code_token, :event_id, :created_at,
         :invited_at, :invite_count

  field :full_name
end
