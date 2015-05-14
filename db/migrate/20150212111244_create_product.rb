ROM::SQL.migration do
  change do
    create_table(:products) do
      primary_key :id
      String :name, null: false
    end
  end
end
