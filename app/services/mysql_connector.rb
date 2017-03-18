class MysqlConnector < DbConnector
  def query(query)
    result = connection.query(query)

    return {
      fields: result.fields,
      result: result.each(as: :array).to_a
    }
  end

  def store_columns_info
    columns_info = connection.query <<-SQL
      SELECT
        TABLE_SCHEMA,
        TABLE_NAME,
        COLUMN_NAME
      FROM INFORMATION_SCHEMA.COLUMNS
      WHERE TABLE_SCHEMA NOT IN ('sys', 'information_schema', 'mysql', 'performance_schema')
    SQL

    persist_columns_info(columns_info.each(as: :array).to_a)
  end

  private

  def connection
    connection_attributes = db_connection.slice("user", "password", "host", "database", "timeout", "port")

    @connection = Mysql2::Client.new(connection_attributes)
  end
end
