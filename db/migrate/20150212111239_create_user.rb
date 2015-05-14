ROM::SQL.migration do
  change do
    create_table(:users) do
      primary_key :id
      String :email, null: false
      String :password_hash, null: false
      String :token, null: false

      index :email, unique: true
      index :token, unique: true
    end
  end
end
