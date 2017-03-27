class Db::Query < ApplicationRecord
  attr_accessor :auto_limit

  belongs_to :connection, foreign_key: :db_connection_id

  delegate :adapter, :database, to: :connection

  validates :body, :connection, :fields, :result, :duration, presence: true

  def as_json(options = {})
    super.merge(
      created_at: created_at.strftime("%d %b %Y %H:%M"),
      database: database,
      body: body,
      results_count: results_count,
      fields: JSON.parse(fields),
      result: JSON.parse(result)
    )
  end

  def run
    t1 = Time.current
    response = connection.connector.query(body)

    self.fields = response[:fields].to_json
    self.result = response[:result].to_json
    self.results_count = response[:result].count
    self.duration = (Time.current - t1)

    save
  end
end
