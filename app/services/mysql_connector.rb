class MysqlConnector < Struct.new(:db_connection_id)
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

    schemas_tables = columns_info.each(as: :array).to_a.group_by(&:first)

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
    db_connection = Db::Connection.find(db_connection_id)

    connection_attributes = db_connection.slice("user", "password", "host", "database", "timeout", "port")

    @connection = Mysql2::Client.new(connection_attributes)
  end
end
