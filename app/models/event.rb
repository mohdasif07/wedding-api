class Event < ApplicationRecord
  belongs_to :user

  has_many :guests, dependent: :destroy
  has_many :photos, dependent: :destroy
  has_many :rsvps, dependent: :destroy
  has_many :attendances, dependent: :destroy

  enum :status, { planned: 0, confirmed: 1, completed: 2, cancelled: 3 }

  validates :title, :event_date, presence: true

  scope :upcoming, -> { where("event_date >= ?", Date.current).order(:event_date) }
  scope :search, ->(query) {
    return all if query.blank?

    where("title ILIKE :q OR venue ILIKE :q OR description ILIKE :q", q: "%#{query}%")
  }
  scope :by_status, ->(status) { where(status: status) if status.present? }
end
