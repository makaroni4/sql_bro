class CreateDbQueries < ActiveRecord::Migration[5.0]
  def change
    create_table :db_queries do |t|
      t.text :body
      t.belongs_to :db_connection, foreign_key: true
      t.json :fields
      t.json :result
      t.text :description
      t.float :duration

      t.timestamps
    end
  end
end
