class Users < ROM::Relation[:sql]
  def ordered
    order(:id)
  end

  def by_id(id)
    where(id: id)
  end

  def login_by(email)
    select(:token, :password_hash).where(email: email)
  end

  def by_token(token)
    where(token: token)
  end
end

