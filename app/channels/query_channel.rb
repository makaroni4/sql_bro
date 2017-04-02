class QueryChannel < ApplicationCable::Channel
  def subscribed
    stream_from "query_channel_#{current_user}"
  end

  def run_query(data)
    db_query = Db::Query.new({
      db_connection_id: data["db_connection_id"],
      description: data["description"],
      body: data["sql_body"],
      auto_limit: data["auto_limit"]
    })

    db_query.run

    db_query_serialization = QueryResultSerializer.new(db_query, {})

    ActionCable.server.broadcast "query_channel_#{current_user}", db_query_serialization.to_json
  rescue Exception => e
    Rails.logger.warn e.message
    Rails.logger.warn e.backtrace.join("\n")

    ActionCable.server.broadcast "query_channel_#{current_user}", { error: e.message }.to_json
  end
end
