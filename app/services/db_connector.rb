class DbConnector
  attr_reader :db_connection

  def initialize(db_connection_id)
    @db_connection = Db::Connection.find(db_connection_id)
  end

  private

  def persist_columns_info(columns_info)
    schemas_tables = columns_info.group_by(&:first)

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

  def persist_table_sizes(table_sizes_query_result)
    table_sizes_query_result.group_by(&:first).each do |schema, values|
      db_schema = db_connection.schemas.find_or_create_by(name: schema)

      values.each do |_, table, size|
        db_table = db_schema.tables.find_or_create_by(name: table)
        db_table.update(
          size: size
        )
      end
    end
  end
end
