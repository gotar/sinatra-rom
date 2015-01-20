require_relative 'base_serializer'

module API
  class ProductSerializer < BaseSerializer
    private
    def self.basic_struct(object)
      {
        id: object[:id],
        name: object[:name]
      }
    end
  end
end
