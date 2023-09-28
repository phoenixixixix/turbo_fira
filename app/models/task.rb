class Task < ApplicationRecord
  enum status: [ :pending, :complete ]

  validates :description, presence: true

  scope :ordered, -> { order(id: :desc) }
end
