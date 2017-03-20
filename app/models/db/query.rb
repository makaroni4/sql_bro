class Db::Query < ApplicationRecord
  belongs_to :connection, foreign_key: :db_connection_id

  delegate :adapter, :database, to: :connection

  validates :body, :connection, :fields, :result, :duration, presence: true

  def as_json(options = {})
    super.merge(
      created_at: created_at.strftime("%d %b %Y %H:%M"),
      database: database,
      results_count: results_count
    )
  end

  def run
    t1 = Time.current
    response = connection.connector.query(body)

    self.fields = response[:fields].to_json
    self.result = response[:result]
    self.results_count = response[:result].count
    self.duration = (Time.current - t1)

    save
  end
end
