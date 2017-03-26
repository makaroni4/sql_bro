class QueryList extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      queries: JSON.parse(this.props.queries)
    };
  }

  insertNewQuery(query) {
    this.setState({
      queries: [query].concat(this.state.queries)
    });
  }

  componentDidMount() {
    App.query.received = function(query) {
      query = JSON.parse(query);
      this.insertNewQuery(query);
    }.bind(this);
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
