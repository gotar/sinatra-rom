class ProductMapper < ROM::Mapper
  relation :products

  attribute :id
  attribute :name
end

