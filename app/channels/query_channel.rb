class QueryChannel < ApplicationCable::Channel
  def subscribed
    stream_from "query_channel_#{current_user}"
  end

  def run_query(data)
    db_query = Db::Query.new({
      db_connection_id: data["db_connection_id"],
      description: data["description"],
      body: data["sql_body"]
    })

    db_query.run

    ActionCable.server.broadcast "query_channel_#{current_user}", db_query.to_json
  end
end
