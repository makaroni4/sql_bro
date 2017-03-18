class Db::Schema < ApplicationRecord
  belongs_to :connection, foreign_key: :db_connection_id
  has_many :tables, foreign_key: :db_schema_id
end
