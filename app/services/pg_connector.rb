class PgConnector < DbConnector
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
          table_schema,
          table_name
        FROM information_schema.tables
        WHERE table_schema not IN ('pg_catalog', 'information_schema')
        AND table_schema not LIKE 'pg_toast%'
      )

      SELECT
        c.table_schema AS schema,
        c.table_name AS table,
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
      SELECT pg_cancel_backend(pid)
      FROM pg_stat_activity
      WHERE
        state = 'active'
        AND query = '#{body}'
        AND application_name = 'sql_bro'
    SQL

    return {
      fields: result.fields,
      result: result.values
    }
  end

  def download_table_sizes
    tables_sizes = connection.exec <<-SQL
      SELECT
        schemaname AS schema,
        relname AS table,
        pg_total_relation_size(relid) AS size
      FROM pg_catalog.pg_statio_user_tables
    SQL

    persist_table_data(tables_sizes.values, :size)
  end

  def download_table_row_counts
    row_counts = connection.query <<-SQL
      SELECT
        nspname AS schema,
        relname AS table,
        reltuples AS rows_count
      FROM pg_class c
      INNER JOIN pg_namespace n
        ON n.oid = c.relnamespace
      WHERE
        nspname not IN ('pg_catalog', 'information_schema', 'pg_toast')
        AND relkind = 'r'
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
    @connection.exec("SET application_name TO 'sql_bro'")
    @connection
  end
end
