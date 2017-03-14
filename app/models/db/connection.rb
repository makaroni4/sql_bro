class Db::Connection < ApplicationRecord
  has_many :queries, foreign_key: :db_connection_id

  def connector
    "#{adapter}_connector".classify.constantize.new(id)
  end
end
