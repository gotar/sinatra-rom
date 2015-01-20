ROM.relation(:products) do
  def all
    order(:id)
  end

  def by_id(id)
    where(id: id)
  end
end

