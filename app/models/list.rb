class List < ActiveRecord::Base
  validates :user_id, presence: true
  has_many :list_items, dependent: :destroy
  belongs_to :user
end
