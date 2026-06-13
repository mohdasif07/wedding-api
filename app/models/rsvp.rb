class Rsvp < ApplicationRecord
  belongs_to :guest
  belongs_to :event

  enum :status, { pending: 0, accepted: 1, declined: 2, maybe: 3 }

  validates :guest_id, uniqueness: { scope: :event_id }

  after_save :sync_guest_rsvp_status

  private

  def sync_guest_rsvp_status
    guest.update_column(:rsvp_status, Guest.rsvp_statuses[status])
  end
end
