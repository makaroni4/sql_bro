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

        is_view = columns.first[2]
        table = schema.tables.find_or_create_by!(name: table_name, is_view: is_view)

        Db::Column.transaction do
          table.columns.delete_all
          db_columns_fields = columns.inject([]) do |a, (_, _, _, column_name)|
            a << [column_name, table.id]
          end

          Db::Column.import([:name, :db_table_id], db_columns_fields)
        end
      end
    end
  end

  def persist_table_data(table_sizes_query_result, key)
    table_sizes_query_result.group_by(&:first).each do |schema, values|
      db_schema = db_connection.schemas.find_or_create_by(name: schema)

      values.each do |_, table, value|
        db_table = db_schema.tables.find_or_create_by(name: table)
        db_table.update(
          key => value
        )
      end
    end
  end
end
