class Task < ApplicationRecord
  enum status: [ :pending, :complete ]

  belongs_to :stack, counter_cache: true

  validates :description, presence: true

  scope :ordered, -> { order(id: :desc) }
end
