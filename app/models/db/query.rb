class Db::Query < ApplicationRecord
  belongs_to :db_connection, class_name: Db::Connection

  delegate :database, to: :db_connection

  def as_json(options = {})
    super.merge(
      created_at: created_at.strftime("%d %b %Y %H:%M"),
      database: database,
      fields: JSON.parse(fields),
      results: JSON.parse(result)
    )
  end

  def run
    t1 = Time.current
    response = db_connection.connector.query(body)

    self.fields = response[:fields].to_json
    self.result = response[:result].to_json
    self.duration = (Time.current - t1)

    save
  end
end
