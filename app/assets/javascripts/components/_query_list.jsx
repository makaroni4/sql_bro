class QueryList extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      queries: JSON.parse(this.props.queries)
    };
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
