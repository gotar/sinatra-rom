class DeleteUser < ROM::Commands::Delete[:sql]
  register_as :delete
  relation :users

  result :one
end
