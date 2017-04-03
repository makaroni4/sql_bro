class Db::Table < ApplicationRecord
  belongs_to :schema, foreign_key: :db_schema_id, class_name: Db::Schema
  has_many :columns, foreign_key: :db_table_id, dependent: :destroy
end
