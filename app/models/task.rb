class Task < ActiveRecord::Base
  validates :description, :start_time, :duration, :user_id, presence: true
  belongs_to :user
end
