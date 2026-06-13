class Task < ApplicationRecord
  belongs_to :user

  enum :status, { pending: 0, in_progress: 1, completed: 2 }

  CATEGORIES = %w[venue guests vendors attire photography catering legal general].freeze

  validates :title, presence: true
  validates :category, inclusion: { in: CATEGORIES }

  scope :ordered, -> { order(position: :asc, created_at: :asc) }
  scope :by_category, ->(category) { where(category: category) if category.present? }
end
