class AddIsViewToDbTables < ActiveRecord::Migration[5.0]
  def change
    add_column :db_tables, :is_view, :boolean, default: false
  end
end
