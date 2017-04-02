class Db::Query < ApplicationRecord
  attr_accessor :auto_limit

  belongs_to :connection, foreign_key: :db_connection_id

  delegate :adapter, :database, to: :connection

  validates :body, :connection, :fields, :result, :duration, presence: true

  def run
    t1 = Time.current

    actual_body = auto_limit ? self.body + "\nLIMIT 100" : self.body

    response = connection.connector.query(actual_body)

    self.fields = response[:fields].to_json
    self.result = response[:result].to_json
    self.results_count = response[:result].count
    self.duration = (Time.current - t1)

    save
  end
end
