class Task < ApplicationRecord
  enum status: [ :pending, :complete ]

  belongs_to :stack

  validates :description, presence: true

  scope :ordered, -> { order(id: :desc) }
end
