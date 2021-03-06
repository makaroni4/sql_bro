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
        c.TABLE_SCHEMA,
        c.TABLE_NAME,
        (CASE WHEN TABLE_TYPE LIKE '%VIEW%' THEN TRUE ELSE FALSE END) AS IS_VIEW,
        COLUMN_NAME
      FROM information_schema.columns c
      INNER JOIN information_schema.tables t
        ON c.TABLE_SCHEMA = t.TABLE_SCHEMA
          AND c.TABLE_NAME = t.TABLE_NAME
      WHERE c.TABLE_SCHEMA NOT IN ('sys', 'information_schema', 'mysql', 'performance_schema');
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

  def download_table_sizes
    tables_sizes = connection.query <<-SQL
      SELECT
        TABLE_SCHEMA,
        TABLE_NAME,
        DATA_LENGTH / 1024 / 1024
      FROM information_schema.tables
      WHERE TABLE_SCHEMA NOT IN ('sys', 'information_schema', 'mysql', 'performance_schema')
    SQL

    persist_table_data(tables_sizes.each(as: :array).to_a, :size)
  end

  def download_table_row_counts
    row_counts = connection.query <<-SQL
      SELECT
        TABLE_SCHEMA,
        TABLE_NAME,
        TABLE_ROWS
      FROM information_schema.tables
      WHERE TABLE_SCHEMA NOT IN ('sys', 'information_schema', 'mysql', 'performance_schema')
    SQL

    persist_table_data(row_counts.each(as: :array).to_a, :rows_count)
  end

  private

  def connection
    connection_attributes = db_connection.slice("database", "host", "password", "timeout", "port")

    connection_attributes["username"] = db_connection.user

    @connection = Mysql2::Client.new(connection_attributes)
  end
end
