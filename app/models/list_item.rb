class ListItem < ActiveRecord::Base
  validates :description, :list_id, 
  :priority, :start_time, :end_time, presence: true
  belongs_to :list
end
