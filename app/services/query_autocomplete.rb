class QueryAutocomplete
  attr_reader :db_connection

  def initialize(db_connection_id)
    @db_connection = Db::Connection.find(db_connection_id)
  end

  def suggest(prefix)
    suggestions = []

    suggestions = db_connection.schemas.select(:name).where("db_schemas.name LIKE ?", "#{prefix}%").map do |schema|
      {
        "word" => schema.name,
        "meta" => "schema"
      }
    end

    suggestions += db_connection.schemas.joins(:tables).select("db_tables.name").where("db_tables.name LIKE ?", "#{prefix}%").map do |table|
      {
        "word" => table.name,
        "meta" => "table"
      }
    end

    suggestions += db_connection.schemas.joins(tables: :columns).select("db_columns.name").where("db_columns.name LIKE ?", "#{prefix}%").distinct("db_columns.name").map do |column|
      {
        "word" => column.name,
        "meta" => "column"
      }
    end

    suggestions
  end
end
