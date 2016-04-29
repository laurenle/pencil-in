# Task model, for adding new to-dos
class Task < ActiveRecord::Base
  validates :description, :start_time, :duration, :user_id, presence: true
  validates_inclusion_of :duration, in: 1..180
  belongs_to :user
end