class Db::Column < ApplicationRecord
  belongs_to :db_table, foreign_key: :db_table_id, class_name: Db::Table
end
