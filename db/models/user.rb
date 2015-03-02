require 'bcrypt'

class User
  include Virtus.model

  attribute :id
  attribute :email
  attribute :password_hash
  attribute :token

  def password
    @password ||= ::BCrypt::Password.new(password_hash)
  end
end
