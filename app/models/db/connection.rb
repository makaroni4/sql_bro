class Db::Connection < ApplicationRecord
  has_many :queries, foreign_key: :db_connection_id
  has_many :schemas, foreign_key: :db_connection_id, dependent: :destroy

  AVAILABLE_ADAPTERS = %w(pg mysql redshift)
  DEFAULT_PORTS = {
    pg: 5432,
    redshift: 5439,
    mysql: 3306
  }.with_indifferent_access

  before_validation :set_defaults, on: :create

  validates :adapter, inclusion: { in: AVAILABLE_ADAPTERS }
  validates :port, presence: true

  def connector
    "#{adapter}_connector".classify.constantize.new(id)
  end

  private

  def set_defaults
    self.port ||= DEFAULT_PORTS[adapter]
    self.host ||= "localhost"
    self.timeout ||= 5000
  end
end
