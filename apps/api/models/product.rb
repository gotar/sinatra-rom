module API
  class Product
    include Virtus.model

    attribute :id, Integer
    attribute :name, String

    def self.[](params)
      new params
    end
  end
end
