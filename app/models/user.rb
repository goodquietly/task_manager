class User < ApplicationRecord
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable,
         :trackable, :lockable

  validates :name, presence: true, length: { maximum: 35 }
  validates :surname, presence: true, length: { maximum: 35 }

  has_many :task_users, class_name: 'Task', foreign_key: 'user_id', dependent: :destroy
  has_many :task_authors, class_name: 'Task', foreign_key: 'author_id', dependent: :destroy

  def send_devise_notification(notification, *args)
    devise_mailer.send(notification, self, *args).deliver_later
  end

  def full_name
    "#{name} #{surname}"
  end
end
