require 'bcrypt'

module API
  class User
    include Virtus.model

    attribute :id, Integer
    attribute :email, String
    attribute :password_hash, String
    attribute :token, String, default: :generate_token


    def password
      @password ||= ::BCrypt::Password.new(password_hash)
    end

    def password=(new_password)
      @password = ::BCrypt::Password.create(new_password)
      self.password_hash = @password
    end

    def self.[](params)
      new params
    end

    private
    def generate_token
      SecureRandom.hex
    end
  end
end
