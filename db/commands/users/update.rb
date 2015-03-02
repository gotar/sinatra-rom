class UpdateUser < ROM::Commands::Update[:sql]
  register_as :update
  relation :users

  input UserParams
  validator UserValidator

  result :one
end
