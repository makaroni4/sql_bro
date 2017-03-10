json.extract! db_query, :id, :body, :db_connection_id, :fields, :result, :description, :duration, :created_at, :updated_at
json.url db_query_url(db_query, format: :json)
