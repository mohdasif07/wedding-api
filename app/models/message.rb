class Message < ApplicationRecord
  belongs_to :user
  belongs_to :event, optional: true
  has_many :message_recipients, dependent: :destroy
  has_many :guests, through: :message_recipients

  enum :message_type, { invitation: 0, announcement: 1, reminder: 2, custom: 3 }

  validates :subject, :body, presence: true

  scope :recent, -> { order(created_at: :desc) }
end
