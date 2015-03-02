require_relative 'base_validator'

class PaginationValidator < BaseValidator
  attribute :page, type: Integer, inclusion: 1..(1/0.0)
  attribute :per_page, type: Integer, inclusion: 1..100
end
