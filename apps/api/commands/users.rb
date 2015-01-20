ROM.commands(:users) do
  define(:create) do
    input API::User
    validator UserValidator
    result :one
  end

  define(:update) do
    result :one
  end

  define(:delete) do
    result :one
  end
end
