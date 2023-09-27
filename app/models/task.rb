class Task < ApplicationRecord
  enum status: { pending: 0, complete: 1}

  validates :description, presence: true
end
