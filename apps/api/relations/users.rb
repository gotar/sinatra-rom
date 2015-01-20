ROM.relation(:users) do
  def all
    order(:id)
  end

  def by_id(id)
    where(id: id)
  end

  def login_by(email)
    select(:token, :password_hash).where(email: email)
  end
end

