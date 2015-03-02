require_relative 'base_validator'

class ProductValidator < BaseValidator
  attribute :name, presence: true
end
