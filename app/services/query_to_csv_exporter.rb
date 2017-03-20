require "csv"

class QueryToCsvExporter
  attr_reader :db_query

  def initialize(db_query_id)
    @db_query = Db::Query.find(db_query_id)
  end

  def filename
    description = (db_query.description || "description").gsub(/[^0-9A-Z]/i, '_').downcase
    description << ".csv"
  end

  def data
    CSV.generate do |csv|
      csv << JSON.parse(db_query.fields)

      JSON.parse(db_query.result).each do |row|
        csv << row
      end
    end
  end
end
