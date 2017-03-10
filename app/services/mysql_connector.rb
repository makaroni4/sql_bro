class MysqlConnector < Struct.new(:db_connection_id)
  def query(query)
    result = connection.query(query)

    return {
      fields: result.fields,
      result: result.each(as: :array).to_a
    }
  end

  private

  def connection
    db_connection = Db::Connection.find(db_connection_id)

    connection_attributes = db_connection.slice("user", "password", "host", "database", "timeout")

    @connection = Mysql2::Client.new(connection_attributes)
  end
end
