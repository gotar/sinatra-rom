class ProductParams
  include Virtus.model

  attribute :name, String

  def self.[](params)
    new params
  end
end
