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
      ::MultiJson.dump(hash, pretty: true)
    end

    def record_not_found(params, fields=[:id])
      json_error(404, "Record Not Found for given #{fields} => #{params}")
    end

    def invalid_params(fields)
      json_error(422, "Invalid data for fields: #{fields.join(', ')}")
    end

    def delete_response
      204
    end

    def rom
      ROM.env
    end

    def convert_time(time)
      case time
      when Time
        time.iso8601
      when String
        Time.parse(time).iso8601 rescue time
      else
        time
      end
    end
  end
end

