class PgConnector < Struct.new(:db_connection_id)
  def query(query)
    result = connection.exec(query)

    return {
      fields: result.fields,
      result: result.values
    }
  end

  def store_columns_info
    columns = connection.exec <<-SQL
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

    schemas_tables = columns.values.group_by(&:first)

    schemas_tables.each do |schema_name, tables|
      next unless tables.any?

      schema = db_connection.schemas.find_or_create_by!(name: schema_name)
      tables_columns = tables.group_by(&:second)

      tables_columns.each do |table_name, columns|
        next unless columns.any?

        table = schema.tables.find_or_create_by!(name: table_name)

        columns.each do |_, _, column_name|
          table.columns.find_or_create_by!(name: column_name)
        end
      end
    end
  end

  private

  def db_connection
    @db_connection ||= Db::Connection.find(db_connection_id)
  end

  def connection
    connection_attributes = db_connection.slice("user", "password", "host", "port")
    connection_attributes["dbname"] = db_connection.database
    connection_attributes["connect_timeout"] = db_connection.timeout

    @connection ||= PG.connect(connection_attributes)
    @connection.type_map_for_results = PG::BasicTypeMapForResults.new(@connection)
    @connection
  end
end
