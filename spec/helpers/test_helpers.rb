module TestHelpers
  def create_product
    product = { name: 'Foo' }
    ROM.env.commands.products.try {
      ROM.env.commands.products.create.call(product)
    }
  end

  def create_user
    begin
      data = {
        email: "example-#{rand(100)}@example.com",
        password: 'password'
      }
      result = ROM.env.commands.users.try {
        ROM.env.commands.users.create.call(data)
      }
    end while result.error
    result
  end
end
