# User model
class User < ActiveRecord::Base
  include BCrypt

  validates :name, :email, :password_hash, presence: true
  validates :name, length: { minimum: 2 }
  validates :password, length: { minimum: 6 }
  validates :email, uniqueness: true
  validate :valid_email?, :capitalized?
  has_many :users_tasks, dependent: :destroy
  has_many :tasks, through: :users_tasks
  has_one :calendar, dependent: :destroy
  before_save :downcase_email

  def password
    @password ||= Password.new(password_hash)
  end

  def password=(new_password)
    @password = Password.create(new_password)
    self.password_hash = @password
  end

  def valid_email?
    if (/\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/ =~ email).nil?
      errors.add(:base, 'Please enter a valid email address.')
    end
  end

  def capitalized?
    unless name.nil? || name.empty?
      matches = name.strip[0].match(/[A-Z]/)
      errors.add(:base, 'Name must be capitalized.') if matches.to_s.empty?
    end
  end

  def downcase_email
    email.downcase!
  end
end
