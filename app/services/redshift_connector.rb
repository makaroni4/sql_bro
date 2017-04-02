class RedshiftConnector < DbConnector
  def query(query)
    result = connection.exec(query)

    return {
      fields: result.fields,
      result: result.values
    }
  end

  def store_columns_info
    columns_info = connection.exec <<-SQL
      WITH tables AS (
        SELECT
          t.table_schema,
          t.table_name,
          (CASE WHEN v.view_definition IS NOT NULL THEN TRUE ELSE FALSE END) AS is_view
        FROM information_schema.tables t
        LEFT JOIN information_schema.views v
          ON v.table_schema = t.table_schema
            AND v.table_name = t.table_name
        WHERE t.table_schema not IN ('pg_catalog', 'information_schema')
        AND t.table_schema not LIKE 'pg_toast%'
      )

      SELECT
        c.table_schema AS schema,
        c.table_name AS table,
        t.is_view AS is_view,
        column_name AS column
      FROM information_schema.columns c
      INNER JOIN tables t
        ON c.table_schema = t.table_schema
          AND c.table_name = t.table_name
    SQL

    persist_columns_info(columns_info.values)
  end

  def cancel_query(body)
    result = connection.exec <<-SQL
      SELECT pid
      FROM stv_recents
      WHERE
        user_name = '#{db_connection.user}'
        AND db_name = '#{db_connection.database}'
        AND query = '#{body}'
        AND status = 'Running'
    SQL

    result.values.flatten.each do |id|
      connection.query <<-SQL
        CANCEL #{id}
      SQL
    end
  end

  def download_table_sizes
    tables_sizes = connection.exec <<-SQL
      SELECT
        i.schema,
        i.table,
        i.size
      FROM svv_table_info i
      WHERE database = '#{db_connection.database}'
    SQL

    persist_table_data(tables_sizes.values, :size)
  end

  def download_table_row_counts
    row_counts = connection.exec <<-SQL
      SELECT
        i.schema,
        i.table,
        i.tbl_rows
      FROM svv_table_info i
      WHERE database = '#{db_connection.database}'
    SQL

    persist_table_data(row_counts.values, :rows_count)
  end

  private

  def connection
    connection_attributes = db_connection.slice("user", "password", "host", "port")
    connection_attributes["dbname"] = db_connection.database
    connection_attributes["connect_timeout"] = db_connection.timeout

    @connection ||= PG.connect(connection_attributes)
    @connection.type_map_for_results = PG::BasicTypeMapForResults.new(@connection)
    @connection
  end
end
