require 'multi_json'
require 'oj'

module API
  module Helpers
    def json_error(code, message)
      error = {
        code: code,
        message: message
      }
      halt code, json(error)
    end

    def json(hash)
      content_type :json
      ::MultiJson.dump(hash)
    end

    def record_not_found(params, fields=[:id])
      json_error(404, "Record Not Found for given #{fields} => #{params}")
    end

    def invalid_params(fields)
      json_error(422, "Invalid data for fields: #{fields.join(', ')}")
    end

    def require_fields(fields)
      missing = fields.map(&:to_s) - params.delete_if{|_,v| v.blank?}.keys
      invalid_params(missing) unless missing.empty?
    end
  end
end
