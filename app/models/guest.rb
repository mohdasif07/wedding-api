class Guest < ApplicationRecord
  belongs_to :event
  has_many :rsvps, dependent: :destroy
  has_many :attendances, dependent: :destroy
  has_many :message_recipients, dependent: :destroy

  enum :side, { bride: 0, groom: 1 }
  enum :rsvp_status, { pending: 0, accepted: 1, declined: 2, maybe: 3 }

  validates :first_name, :last_name, :qr_code_token, presence: true
  validates :qr_code_token, uniqueness: true

  before_validation :generate_qr_code_token, on: :create

  scope :search, ->(query) {
    return all if query.blank?

    where(
      "first_name ILIKE :q OR last_name ILIKE :q OR email ILIKE :q OR family_name ILIKE :q",
      q: "%#{query}%"
    )
  }
  scope :by_rsvp, ->(status) { where(rsvp_status: status) if status.present? }
  scope :by_side, ->(side) { where(side: side) if side.present? }

  def full_name
    "#{first_name} #{last_name}".strip
  end

  def invited?
    invited_at.present?
  end

  def invitation_text
    event = self.event
    <<~TEXT.strip
      Dear #{full_name},

      You are cordially invited to #{event.title}!
      Date: #{event.event_date}
      Venue: #{event.venue || 'TBA'}
      Time: #{event.start_time.present? ? event.start_time.strftime('%I:%M %p') : 'TBA'}

      Please RSVP for our celebration. Your invitation code: #{qr_code_token}

      With love,
      Wedding Planner Team
    TEXT
  end

  private

  def generate_qr_code_token
    self.qr_code_token ||= SecureRandom.urlsafe_base64(32)
  end
end
