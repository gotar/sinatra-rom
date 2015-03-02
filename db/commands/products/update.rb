class UpdateProduct < ROM::Commands::Update[:sql]
  register_as :update
  relation :products

  input ProductParams
  validator ProductValidator

  result :one
end
