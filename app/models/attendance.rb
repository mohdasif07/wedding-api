class Attendance < ApplicationRecord
  belongs_to :guest
  belongs_to :event

  validates :guest_id, uniqueness: { scope: :event_id }
  validates :checked_in_at, presence: true
end
