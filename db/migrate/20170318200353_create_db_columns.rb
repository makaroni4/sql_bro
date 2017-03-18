class CreateDbColumns < ActiveRecord::Migration[5.0]
  def change
    create_table :db_columns do |t|
      t.belongs_to :db_table, foreign_key: true
      t.string :name

      t.timestamps
    end

    add_index :db_columns, [:db_table_id, :name], unique: true
  end
end
