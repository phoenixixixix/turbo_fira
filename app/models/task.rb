class Task < ApplicationRecord
  enum status: [ :pending, :complete ]

  validates :description, presence: true
end
