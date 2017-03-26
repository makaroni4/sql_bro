class QueryResultTable extends React.Component {
  render() {
    let readJsonProp = function(value) {
      return typeof value === "string" ? JSON.parse(value) : value;
    };

    let fields = readJsonProp(this.props.fields);
    let results = readJsonProp(this.props.results);

    fields = fields.map(function(field) {
      return <th>{field}</th>;
    });
    let tableRow = function(values) {
      return values.map(function(value) {
        if(Object.prototype.toString.call(value) === '[object Array]') {
          return <td>{value.join(", ")}</td>;
        } else {
          return <td>{value}</td>;
        }
      });
    };
    results = results.map(function(values) {
      return <tr>{tableRow(values)}</tr>;
    });

    return (
      <table>
        <thead>
          <tr>
            { fields }
          </tr>
        </thead>
        <tbody>
          { results }
        </tbody>
      </table>
    )
  }
}
