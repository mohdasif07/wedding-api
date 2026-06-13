class DeviceToken < ApplicationRecord
  belongs_to :user

  validates :token, :platform, presence: true
  validates :token, uniqueness: true
end
