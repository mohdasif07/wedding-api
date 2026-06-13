class Photo < ApplicationRecord
  belongs_to :event, optional: true
  belongs_to :album, optional: true

  has_one_attached :image

  validates :image, presence: true
  validate :event_or_album_present

  scope :for_event, ->(event_id) { where(event_id: event_id) if event_id.present? }
  scope :for_album, ->(album_id) { where(album_id: album_id) if album_id.present? }

  private

  def event_or_album_present
    return if event_id.present? || album_id.present?

    errors.add(:base, "must belong to an event or album")
  end
end
