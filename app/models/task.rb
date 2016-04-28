class Task < ActiveRecord::Base
  validates :description, :start_time, :duration, :user_id, presence: true
  validates_inclusion_of :number, :in => 1..120
  belongs_to :user
end
