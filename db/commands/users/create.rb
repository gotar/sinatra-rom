class CreateUser < ROM::Commands::Create[:sql]
  register_as :create
  relation :users

  input NewUserParams
  validator UserValidator

  result :one
end
