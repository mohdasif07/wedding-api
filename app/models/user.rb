class User < ApplicationRecord
  has_secure_password

  enum :role, { family_member: 0, admin: 1 }

  has_many :events, dependent: :destroy
  has_many :vendors, dependent: :destroy
  has_many :expenses, dependent: :destroy
  has_many :albums, dependent: :destroy
  has_many :refresh_tokens, dependent: :destroy
  has_many :password_reset_tokens, dependent: :destroy
  has_many :device_tokens, dependent: :destroy
  has_many :messages, dependent: :destroy
  has_many :tasks, dependent: :destroy

  validates :first_name, :last_name, :email, presence: true
  validates :email, uniqueness: { case_sensitive: false },
                    format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :password, length: { minimum: 8 }, if: -> { password.present? }

  before_validation :normalize_email

  def full_name
    "#{first_name} #{last_name}".strip
  end

  def admin?
    role == "admin"
  end

  private

  def normalize_email
    self.email = email.to_s.downcase.strip
  end
end
