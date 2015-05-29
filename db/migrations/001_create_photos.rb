Sequel.migration do
  change do
    create_table :photos do
      column :id,          :varchar
      column :source,      :varchar
      column :description, :varchar
      column :images,      :jsonb
      column :uploaded_at, :timestamp
      column :tags,        :varchar

      primary_key [:id, :source]
    end
  end
end
