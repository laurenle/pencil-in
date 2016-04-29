class Event < ActiveRecord::Base
  belongs_to :calendar
  validates :start, :end, presence: true
end
