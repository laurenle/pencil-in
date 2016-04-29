# Calendar model, for recording Google API callbacks
class Calendar < ActiveRecord::Base
  belongs_to :user
  has_many :events, dependent: :destroy
  validates :user_id, presence: true
end
