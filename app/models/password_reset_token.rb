class PasswordResetToken < ApplicationRecord
  belongs_to :user

  validates :token_digest, :expires_at, presence: true

  scope :active, -> { where(used_at: nil).where("expires_at > ?", Time.current) }

  def used?
    used_at.present?
  end

  def mark_used!
    update!(used_at: Time.current)
  end
end
