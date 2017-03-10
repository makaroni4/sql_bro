class CreateDbConnections < ActiveRecord::Migration[5.0]
  def change
    create_table :db_connections do |t|
      t.string :adapter
      t.string :user
      t.string :password
      t.string :host
      t.string :encoding
      t.integer :timeout
      t.string :database

      t.timestamps
    end
  end
end
