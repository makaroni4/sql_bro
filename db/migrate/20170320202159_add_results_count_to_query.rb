class AddResultsCountToQuery < ActiveRecord::Migration[5.0]
  def change
    add_column :db_queries, :results_count, :integer
  end
end
