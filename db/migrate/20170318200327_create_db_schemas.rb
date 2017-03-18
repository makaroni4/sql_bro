class CreateDbSchemas < ActiveRecord::Migration[5.0]
  def change
    create_table :db_schemas do |t|
      t.belongs_to :db_connection, foreign_key: true
      t.string :name

      t.timestamps
    end

    add_index :db_schemas, [:db_connection_id, :name], unique: true
  end
end
