ROM::SQL::Migration.create do
  change do
    create_table(:users) do
      primary_key :id
      String :email
      String :password_hash
      String :token
    end
  end
end
