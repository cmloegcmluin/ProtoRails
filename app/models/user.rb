require_relative '../../lib/active_record_lite/sql_object.rb'
require 'byebug'
require 'bcrypt'

class User < SQLObject
  # validates :username, :session_token, presence: true, uniqueness: true
  # validates :password_digest, presence: { message: "Password can't be blank"}

  #validates :password, length: { minimum: 6 } #allow_nil: true

  #after_initialize :ensure_session_token

  attr_accessor :password

  def self.find_by_credentials(email, password)
    @user = User.where({"email" => email}).first
    #debugger
    return nil if @user.nil?
    @user.is_password?(password) ? @user : nil
  end

  def is_password?(password)
    BCrypt::Password.new(self.password_digest).is_password?(password)
  end

  def password=(password)
    @password = password
    self.password_digest = BCrypt::Password.create(password)
  end

  def reset_session_token!
    self.session_token = self.class.generate_session_token
    self.save
    self.session_token
  end

  def self.generate_session_token
    SecureRandom.urlsafe_base64
  end

  # def ensure_session_token
  #   self.session_token ||= self.class.generate_session_token
  # end

  self.finalize!
end
