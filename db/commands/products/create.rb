class CreateProduct < ROM::Commands::Create[:sql]
  register_as :create
  relation :products

  input ProductParams
  validator ProductValidator

  result :one
end
