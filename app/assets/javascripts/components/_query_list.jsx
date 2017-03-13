class QueryList extends React.Component {
  constructor(props) {
    super(props);
    this.state = {

    };
  }

  render() {
    let queries = JSON.parse(this.props.queries);
    let listItems = queries.map(function(query) {
      return <QueryListItem query={query} key={query.id} />;
    });

    return (
      <div>
        {listItems}
      </div>
    );
  }
}
