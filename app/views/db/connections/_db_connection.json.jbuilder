json.extract! db_connection, :id, :adapter, :user, :password, :host, :timeout, :database, :created_at, :updated_at
json.url db_connection_url(db_connection, format: :json)
