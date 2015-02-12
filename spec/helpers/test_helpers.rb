module TestHelpers
  def create_product
    product = {
      name: 'foo'
    }
    ROM.env.command(:products).try {
      ROM.env.command(:products).create.call(product)
    }
  end

  def create_user
    data = {
      email: 'example@example.com',
      password: 'password'
    }
    ROM.env.command(:users).try {
      ROM.env.command(:users).create.call(data)
    }
  end
end
