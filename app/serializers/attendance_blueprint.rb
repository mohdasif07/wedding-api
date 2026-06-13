class AttendanceBlueprint < Blueprinter::Base
  identifier :id

  fields :guest_id, :event_id, :checked_in_at, :created_at

  view :with_guest do
    association :guest, blueprint: GuestBlueprint do |attendance|
      attendance.guest
    end
  end
end
