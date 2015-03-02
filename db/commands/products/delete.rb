class DeleteProduct < ROM::Commands::Delete[:sql]
  register_as :delete
  relation :products

  result :one
end
