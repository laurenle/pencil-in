class User < ActiveRecord::Base
  include BCrypt

  validates :name, :email, :password_hash, presence: true
  validates :name, length: { minimum: 2 }
  validates :password, length: { minimum: 6 }
  validates :email, uniqueness: true
  validate :valid_email?, :capitalized?
  has_many :tasks, dependent: :destroy
  before_save :downcase_email

  def password
    @password ||= Password.new(password_hash)
  end

  def password=(new_password)
    @password = Password.create(new_password)
    self.password_hash = @password
  end

  def valid_email?
    unless @email =~ /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i
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
    self.email.downcase!
  end
end
