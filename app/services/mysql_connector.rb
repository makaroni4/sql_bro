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

  def cancel_query(body)
    result = connection.query <<-SQL
      SELECT ID
      FROM INFORMATION_SCHEMA.PROCESSLIST
      WHERE
          USER = '#{db_connection.user}'
          AND DB = '#{db_connection.database}'
          AND INFO = '#{body}'
    SQL

    result.each(as: :array).to_a.flatten.each do |id|
      connection.query <<-SQL
        KILL #{id}
      SQL
    end
  end

  private

  def connection
    connection_attributes = db_connection.slice("database", "host", "password", "timeout", "port")

    connection_attributes["username"] = db_connection.user

    @connection = Mysql2::Client.new(connection_attributes)
  end
end
