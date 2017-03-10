class Db::Query < ApplicationRecord
  belongs_to :db_connection, class_name: Db::Connection

  def run
    t1 = Time.current
    response = db_connection.connector.query(body)

    self.fields = response[:fields].to_json
    self.result = response[:result].to_json
    self.duration = (Time.current - t1)

    save
  end
end
