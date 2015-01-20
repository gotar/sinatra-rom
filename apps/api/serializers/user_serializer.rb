require_relative 'base_serializer'

module API
  class UserSerializer < BaseSerializer
    private
    def self.basic_struct(object)
      {
        id: object[:id],
        email: object[:email],
        token: object[:token]
      }
    end
  end
end
