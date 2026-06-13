class PhotoBlueprint < Blueprinter::Base
  identifier :id

  fields :caption, :event_id, :album_id, :created_at

  field :image_url do |photo, options|
    if photo.image.attached?
      Rails.application.routes.url_helpers.rails_blob_url(
        photo.image,
        host: options[:host] || ENV.fetch("APP_URL", "http://localhost:3000")
      )
    end
  end

  field :thumbnail_url do |photo, options|
    next unless photo.image.attached?

    variant = photo.image.variant(resize_to_limit: [400, 400]).processed
    Rails.application.routes.url_helpers.rails_representation_url(
      variant,
      host: options[:host] || ENV.fetch("APP_URL", "http://localhost:3000")
    )
  rescue StandardError
    nil
  end
end
