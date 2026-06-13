class Expense < ApplicationRecord
  belongs_to :user

  enum :category, {
    venue: 0,
    catering: 1,
    decoration: 2,
    photography: 3,
    jewelry: 4,
    travel: 5,
    miscellaneous: 6
  }

  enum :payment_status, { unpaid: 0, partial: 1, paid: 2 }

  validates :title, :category, presence: true
  validates :estimated_amount, :actual_amount, numericality: { greater_than_or_equal_to: 0 }

  scope :search, ->(query) {
    return all if query.blank?

    where("title ILIKE :q OR remarks ILIKE :q", q: "%#{query}%")
  }
  scope :by_category, ->(category) { where(category: category) if category.present? }
  scope :by_payment_status, ->(status) { where(payment_status: status) if status.present? }
end
