App.query = App.cable.subscriptions.create("QueryChannel", {
  run: function(db_connection_id, sql_body, description) {
    return this.perform("run_query", {
      db_connection_id: db_connection_id,
      sql_body: sql_body,
      description: description
    });
  },
  received: function(data) {
    console.log("--> received " + data);
  }
});
