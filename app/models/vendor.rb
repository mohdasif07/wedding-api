class Vendor < ApplicationRecord
  belongs_to :user

  enum :vendor_type, {
    photographer: 0,
    caterer: 1,
    decorator: 2,
    makeup_artist: 3,
    dj: 4,
    other: 5
  }

  validates :vendor_name, :vendor_type, presence: true
  validates :contract_amount, :paid_amount, numericality: { greater_than_or_equal_to: 0 }

  scope :search, ->(query) {
    return all if query.blank?

    where(
      "vendor_name ILIKE :q OR contact_person ILIKE :q OR email ILIKE :q",
      q: "%#{query}%"
    )
  }
  scope :by_type, ->(type) { where(vendor_type: type) if type.present? }

  def balance_due
    contract_amount.to_d - paid_amount.to_d
  end
end
