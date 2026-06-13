class AlbumBlueprint < Blueprinter::Base
  identifier :id

  fields :title, :description, :created_at

  field :photos_count do |album|
    album.photos.count
  end

  view :detailed do
    association :photos, blueprint: PhotoBlueprint
  end
end
