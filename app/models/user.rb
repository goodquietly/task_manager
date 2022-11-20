class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :trackable

  validates :name, presence: true, length: { maximum: 35 }
  validates :surname, presence: true, length: { maximum: 35 }

  has_many :tasks, dependent: :destroy

  def full_name
    "#{name} #{surname}"
  end
end
