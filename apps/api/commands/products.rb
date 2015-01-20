ROM.commands(:products) do
  define(:create) do
    input API::Product
    validator ProductValidator
    result :one
  end

  define(:update) do
    result :one
  end

  define(:delete) do
    result :one
  end
end
