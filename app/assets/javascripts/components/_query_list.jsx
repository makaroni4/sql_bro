class QueryList extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      queries: JSON.parse(this.props.queries)
    };
  }

  insertNewQuery(query) {
    query = JSON.parse(query);
    this.setState({
      queries: [query].concat(this.state.queries)
    });
  }

  setupActionCable() {
    App.query = App.cable.subscriptions.create("QueryChannel", {
      run: function(db_connection_id, sql_body, description) {
        return this.perform("run_query", {
          db_connection_id: db_connection_id,
          sql_body: sql_body,
          description: description
        });
      },
      received: function(query) {
        this.insertNewQuery(query);
      }.bind(this)
    });
  }

  componentDidMount() {
    this.setupActionCable();
  }

  render() {
    let listItems = this.state.queries.map(function(query) {
      return <QueryListItem query={query} queryId={query.id} />;
    });

    return (
      <div>
        {listItems}
      </div>
    );
  }
}
