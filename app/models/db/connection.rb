class Db::Connection < ApplicationRecord
  has_many :queries, foreign_key: :db_connection_id

  AVAILABLE_ADAPTERS = %w(pg mysql)

  validates :adapter, inclusion: { in: AVAILABLE_ADAPTERS }

  def connector
    "#{adapter}_connector".classify.constantize.new(id)
  end
end
