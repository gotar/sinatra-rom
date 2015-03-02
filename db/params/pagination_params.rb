class PaginationParams
  include Virtus.model

  attribute :page, Integer, default: 1
  attribute :per_page, Integer, default: lambda {|_,_| Products.per_page }
end
