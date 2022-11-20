class Task < ApplicationRecord
  validates :title, presence: true, length: { maximum: 35 }

  enum :status, { created: 0, started: 1, finished: 2 }

  belongs_to :user
  belongs_to :author, class_name: 'User'
end
