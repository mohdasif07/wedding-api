class Album < ApplicationRecord
  belongs_to :user
  has_many :photos, dependent: :destroy

  validates :title, presence: true

  scope :search, ->(query) {
    return all if query.blank?

    where("title ILIKE :q OR description ILIKE :q", q: "%#{query}%")
  }
end
