class EventBlueprint < Blueprinter::Base
  identifier :id

  fields :title, :description, :venue, :event_date, :start_time, :end_time, :status, :created_at

  field :guests_count do |event|
    event.guests.count
  end

  field :photos_count do |event|
    event.photos.count
  end

  view :detailed do
    association :guests, blueprint: GuestBlueprint
    association :photos, blueprint: PhotoBlueprint
  end
end
