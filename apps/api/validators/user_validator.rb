require_relative 'base_validator'

class UserValidator < BaseValidator
  attribute :email, presence: true
  attribute :password_hash, presence: true
end
