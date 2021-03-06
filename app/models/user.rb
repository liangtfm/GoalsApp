class User < ActiveRecord::Base
  attr_accessible :username, :password, :session_token, :admin
  attr_reader :password

  before_validation :ensure_session_token
  validates :username, :password_digest, :session_token, presence: true
  validates :password, length: { minimum: 6, allow_nil: true }
  validates :username, uniqueness: true

  has_many(
    :goals,
    class_name: "Goal",
    foreign_key: :user_id,
    primary_key: :id,
    dependent: :destroy
  )

  def self.find_by_credentials(username, password)
    @user = User.find_by_username(username)

    if @user && @user.is_password?(password)
      @user
    else
      nil
    end
  end

  def password=(new_password)
    @password = new_password
    self.password_digest = BCrypt::Password.create(@password)
  end

  def is_password?(guess)
    BCrypt::Password.new(self.password_digest).is_password?(guess)
  end

  def reset_session_token!
    self.session_token = SecureRandom.urlsafe_base64(16)
    self.save!
    self.session_token
  end

  def ensure_session_token
    self.session_token ||= SecureRandom.urlsafe_base64(16)
  end

end
