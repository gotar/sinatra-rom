class Products < ROM::Relation[:sql]
  include ROM::SQL::Plugin::Pagination

  per_page 30

  def ordered
    order(:id)
  end

  def by_id(id)
    where(id: id)
  end
end
