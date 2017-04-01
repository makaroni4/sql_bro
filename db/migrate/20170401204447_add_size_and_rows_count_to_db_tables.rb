class AddSizeAndRowsCountToDbTables < ActiveRecord::Migration[5.0]
  def change
    add_column :db_tables, :size, :bigint
    add_column :db_tables, :rows_count, :bigint
  end
end
