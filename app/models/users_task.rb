class UsersTask < ActiveRecord::Base
  validates_uniqueness_of :user_id, scope: :task_id
  belongs_to :user
  belongs_to :task
end
