ROM::SQL::Migration.create do
  change do
    create_table(:products) do
      primary_key :id
      String :name, null: false
    end
  end
end
