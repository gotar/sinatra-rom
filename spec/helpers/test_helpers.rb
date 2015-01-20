module TestHelpers
  def create_product
    product = {
      name: 'foo'
    }
    ROM.env.command(:products).try { create(product) }
  end

  def create_user
    data = {
      email: 'example@example.com',
      password: 'password'
    }
    ROM.env.command(:users).try { create(data) }
  end
end
