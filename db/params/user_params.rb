require 'bcrypt'

class UserParams
  include Virtus.model

  attribute :email, String
  attribute :password_hash, String

  def password=(new_password)
    self.password_hash = ::BCrypt::Password.create(new_password)
  end

  def self.[](params)
    new params
  end
end
