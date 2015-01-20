require 'lotus/validations'

class ValidationError < StandardError
  attr_reader :params, :message

  def initialize(obj)
    @params = obj.errors.map(&:attribute)
    @message = "Invalid data for fields: #{params.join(', ')}"
  end
end

class BaseValidator
  include Lotus::Validations

  def self.call(params)
    obj = new(params)
    raise ValidationError.new(obj) unless obj.valid?
  end
end
