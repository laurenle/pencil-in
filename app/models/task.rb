# Task model, for adding new to-dos
class Task < ActiveRecord::Base
  validates :description, :start_time, :duration, presence: true
  validates_inclusion_of :duration, in: 1..180
  has_many :users_tasks, dependent: :destroy
  has_many :users, through: :users_tasks
end