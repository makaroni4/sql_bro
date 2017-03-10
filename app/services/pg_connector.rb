class PgConnector < Struct.new(:db_connection_id)
  def query(query)
    result = connection.exec(query)

    return {
      fields: result.fields,
      result: result.values
    }
  end

  private

  def connection
    db_connection = Db::Connection.find(db_connection_id)

    connection_attributes = db_connection.slice("user", "password", "host")
    connection_attributes["dbname"] = db_connection.database
    connection_attributes["connect_timeout"] = db_connection.timeout

    @connection ||= PG.connect(connection_attributes)
    @connection.type_map_for_results = PG::BasicTypeMapForResults.new(@connection)
    @connection
  end
end
