class User < ActiveRecord::Base
  include BCrypt

  validates :name, :email, :password_hash, presence: true
  validates :name, length: { minimum: 2 }
  validates :name, uniqueness: true
  has_many :lists, dependent: :destroy

  def password
    @password ||= Password.new(password_hash)
  end

  def password=(new_password)
    @password = Password.create(new_password)
    self.password_hash = @password
  end
end
