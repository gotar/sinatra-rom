require 'bcrypt'

class NewUserParams
  include Virtus.model

  attribute :email, String
  attribute :password_hash, String
  attribute :token, String, default: :generate_token

  def password=(new_password)
    self.password_hash = ::BCrypt::Password.create(new_password)
  end

  def self.[](params)
    new params
  end

  private
  def generate_token
    SecureRandom.hex
  end
end
