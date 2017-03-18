class CreateDbTables < ActiveRecord::Migration[5.0]
  def change
    create_table :db_tables do |t|
      t.belongs_to :db_schema, foreign_key: true
      t.string :name

      t.timestamps
    end

    add_index :db_tables, [:db_schema_id, :name], unique: true
  end
end
