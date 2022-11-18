class Task < ApplicationRecord
  enum :status, %i[new started finished]

  belongs_to :user
  belongs_to :author, class_name: 'User'
end
